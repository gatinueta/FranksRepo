#!/usr/bin/env perl

# ====================================================================================
# convert ZV data on KR as needed by KR bkg processes
# 
# ====================================================================================

# ====================================================================================
# Update history :
#
# Date       Who   What                                                         Ref
# ====================================================================================
# 08.10.12   FAM   First version                                                -
# ====================================================================================

# run ifc using 
# cd D:\source\trunk\database\basisscripts\common
# perl -I ../kr interface_scheduler.pl --process IFC_DAEM --line=D --system=KR1

package ifc_daem;

use strict;
use warnings;
use 5.010;

use autodie;
use Readonly;

use File::Basename;
use File::Path;

use common_interface_lib qw( setup_logger write_log_db log_deinit exec_sql exec_sql_proc get_interface_detail commit :CONSTANTS );

use base 'Exporter';
our @EXPORT_OK = qw( run_interface alarming cleanup );

Readonly my $LOGGER_NAME     => 'DAEM';
Readonly my $IMAGE_PATH      => 'IMAGE_PATH';
Readonly my $EXTRACT_PER_RUN => 'EXTRACT_PER_RUN';

# configuration attributes
my ($uows_per_run, $extract_per_run, $file_path);

# TODO add some wheres
Readonly my $GET_KEY_TO_EXTRACT_SQL => << 'EOS';
SELECT pst_nr, datum, ws_nr, uow_id, doc_id FROM
(
  SELECT k.pst_nr, k.datum, k.ws_nr, k.uow_id, k.doc_id 
  FROM zv_tx_key k, zv_uow_status s
  WHERE k.extr_kr IS NULL
  AND k.pst_nr=s.pst_nr(+)
  AND k.datum=s.datum(+)
  AND k.ws_nr=s.ws_nr(+)
  AND k.uow_id=s.uow_id(+)
  AND s.uow_closed(+) is not null
  ORDER BY s.reg_datum, k.reg_datum
)
WHERE rownum<?
EOS

Readonly my $GET_COMPLETE_UOWS_SQL => << 'EOS';
SELECT pst_nr, datum, ws_nr, uow_id FROM
(
  SELECT pst_nr, datum, ws_nr, uow_id
  FROM zv_uow_status s
  WHERE 1=1 -- s.status='?' #TODO
  AND NOT EXISTS(
    SELECT 1 FROM zv_tx_key k
    WHERE k.pst_nr=s.pst_nr
    AND k.datum=s.datum
    AND k.ws_nr=s.ws_nr
    AND k.uow_id=s.uow_id
    AND k.extr_kr IS NULL
  )
)
WHERE rownum<?
EOS

Readonly my $GET_FROM_DGRP_QUEUE_SQL => << 'EOS';
select * 
FROM zv_dgrp_queue
WHERE pst_nr=?
and datum=?
and leser_id=?
and uow_id=?
and doc_id=?
EOS

# %ATTRIBUTES_DGRP
# defines how to obtain the value for each
# column of ZV_DGRP:
#
# for columns that have no definition,
# its value is simply copied from ZV_DGRP_QUEUE.
# Otherwise, the defintion is a hash ref with the attributes 'action' and 'name'
# if the 'action' attribute is undefined, the column is copied with the column name defined in attribute 'name'.
# if the 'action' attribute is 'skip', the value is left empty (NULL) on insert.
# Otherwise, the action is a function taking the column name and the ZV_DGRP_QUEUE row as an argument and returning the column value.

Readonly my %ATTRIBUTES_DGRP => (
  PST_ID          => { name => 'PST_NR' },
  LESER_ID        => { name => 'WS_NR' },
  STEP_NR         => { action => \&from_flow },
  STEP_TYPE_CLASS => { action => \&from_flow },
  UOW_TYPE        => { action => \&from_flow },
  DRUCK_ORT_1      => { action => 'skip' },
  DRUCK_ORT_2      => { action => 'skip' },
  UEBERNAHME       => { action => 'skip' },
  STORNIERT        => { action => 'skip' },
);

sub get_pathname {
    my ($path, $pst_nr, $datum, $ws_nr, $uow_id, $docid) = @_;
    
    #TODO steal this from somewhere
    
    return "$path/$pst_nr/$datum/$ws_nr/$uow_id/$docid.img";
}


sub extract_images {
    my $sth = exec_sql( $GET_KEY_TO_EXTRACT_SQL, $extract_per_run );
    my ($nof_processed, $nof_extracted) = (0, 0);
    
    while (my @pkey = $sth->fetchrow_array()) {
#      my ($pst_nr, $datum, $ws_nr, $uow_id, $docid) = @pkey;

      my $sth_image = exec_sql(
        'SELECT bin_data from zv_bin_data where pst_nr=? AND datum=? AND ws_nr=? AND uow_id=? AND doc_id=?', 
        @pkey);      
      
      eval {
        if (my ($blob) = $sth_image->fetchrow_array()) {
          my $pathname = get_pathname( $file_path, @pkey );
          mkpath dirname $pathname;
          open my $fh, '>', $pathname;
          binmode $fh;
          
          print $fh $blob;
          
          close $fh;
          
          write_log_db($LOGGER_NAME, DEBUG_LVL, "extracted file for @pkey");
          $nof_extracted++;     
        }
        exec_sql( 
          'UPDATE ZV_TX_KEY SET EXTR_KR=sysdate WHERE pst_nr=? AND datum=? AND ws_nr=? AND uow_id=? AND docid=?', 
          @pkey);
        
        write_log_db($LOGGER_NAME, DEBUG_LVL, "finished extraction for @pkey");  
        $nof_processed++;        
      };
      if ($@) {
        write_log_db($LOGGER_NAME, WARN_LVL, "failure extracting file: $@");
      }
      $sth_image->finish();
    }  
    commit();      
    write_log_db($LOGGER_NAME, INFO_LVL, "processed $nof_processed entries, extracted $nof_extracted files" );
}
  
sub convert_zvdgrp {
    my $uow_sth = exec_sql( $GET_COMPLETE_UOWS_SQL, $uows_per_run );
    
    while (my @uow = $uow_sth->fetchrow_array()) {
        my ($pst_nr, $datum, $ws_nr, $uow_id) = @uow;
      
        my $doc_sth = exec_sql( $GET_FROM_DGRP_QUEUE_SQL, @uow);
      
        while (my $doc_href = $doc_sth->fetchrow_hashref()) {
            my %zv_dgrp;
            my $docid = $doc_href->{'DOC_ID'};
            
	    my $sth_cols_dgrp = exec_sql(q(SELECT column_name FROM all_tab_columns WHERE owner='ZVDATA' AND table_name='ZV_DGRP'));
	    while(my ($col) = $sth_cols_dgrp->fetchrow_array()) {
                my $action_def = $ATTRIBUTES_DGRP{$col};
		            
                if (!defined $action_def) {
                    if (!exists($doc_href->{$col})) {
                        die "can't find $col in ZV_DGRP_QUEUE";
                    }
                    $zv_dgrp{$col} = $doc_href->{$col};
                } elsif (!defined $action_def->{'action'}) {
                    my $name = $action_def->{'name'} or die "no name or action defined for $key";
                    $zv_dgrp{$name} = $doc_href->{$col};
                } else {
                    my $action = $action_def->{'action'};
                    if ($action eq 'skip') {
                    } else {
                        $zv_dgrp{$col} = &$action($doc_href, $col);
                    }
                }
            } 
            insert_into_zv_dgrp(\%zv_dgrp);
            write_log_db($LOGGER_NAME, DEBUG_LVL, "inserted @uow docid=$docid"); 
            # TODO update uow 
        }
        commit();
    }
}

# ====================================================================================
#  run_interface: runs interface
#
# Input  : none
# Output : none
# ====================================================================================
sub run_interface{
    #initialise
    setup_logger($LOGGER_NAME); 
#TODO
#    $dbh->{LongReadLen} = 10000000; 
    # read ifc details
    $file_path =       get_interface_detail($IMAGE_PATH,         C_VALUE_1) or die "missing $IMAGE_PATH configuration";
    $extract_per_run = get_interface_detail($EXTRACT_PER_RUN,    N_VALUE_1) || 20;
    $uows_per_run =    get_interface_detail($EXTRACT_PER_RUN,    N_VALUE_2) || 5;
    
    write_log_db($LOGGER_NAME, DEBUG_LVL, "Start!");
    
    extract_images();

    convert_zvdgrp();
    
}

sub insert_into_zv_dgrp {
    my ($zv_dgrp_href) = @_;
    my %zv_dgrp = %$zv_dgrp_href;
    
    my $keys = join (', ', keys %zv_dgrp);
    my @values_list = ('?') x scalar keys %zv_dgrp;
    my $values = join ', ', @values_list;
    
    my $sth = exec_sql("INSERT INTO ZV_DGRP ($keys) VALUES ($values)", values %zv_dgrp); 
}

sub from_flow {
    my ($doc_href, $key) = @_;
    
    given($key) {
        when ('STEP_TYPE_NR') {
            if ($doc_href->{'VERARB_ART_ID'} == 0) {
                return 970;
            } else {
                return 980;
            }
        }
        when ('STEP_TYPE_CLASS') {
            #TODO check
            return 1;
        }
        when ('STEP_NR') {
            #TODO check
            return 1;
        }
        when ('UOW_TYPE') {
            #TODO check
            if ($doc_href->{'VERARB_ART_ID'} == 0) {
                return 55;
            } else {
                return 56;
            }
        }
        default {
            die "don't know key $key";
        }
    }
}
            
        
# ====================================================================================
  
  
# ====================================================================================
#  alarming: if no file processed in the last x (configured) days, 
#            write error to logger_table
#
# Input  : none
# Output : none
# ====================================================================================
sub alarming{
    #TODO
}
# ====================================================================================


# ====================================================================================
#  cleanup: keep up to configured amount of data files, delete the rest
#
# Input  : none
# Output : none
# ====================================================================================
sub cleanup{
    #TODO
}
# ====================================================================================    

1;
