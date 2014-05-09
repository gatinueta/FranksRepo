package UpdateSolrSvn;
use strict;

use base qw(Exporter);
our @EXPORT    = qw(update_solrsvn);
our @EXPORT_OK = qw(testARGV);

use UpdateSolr qw(init_solr send_to_solr commit_solr close_solr isolatin2utf8 xmltime dump_solr cleanup_solr set_curl_cmd set_update_url set_full_load set_debug log_info log_error log_debug);

use Getopt::Long;
use File::Find ();

sub wanted;
my ($find_subcoll_name, $find_checkoutdir, $find_svnroot);

sub testARGV {
    print "\@ARGV is @ARGV\n";
}

my $solr_password = 'BSI$search11';
my $svn_prog = "C:/Programme/Subversion/bin/svn.exe";

sub getdirname {
    my $url = shift;

    $url =~ s|/|_|g;
    if ($url =~ /((_[^_]*){3})$/) {
        return $1;
    } else {
        return $url;
    }
}

sub update_solrsvn {
    if (@_ != 4) {
        die "Usage: update_solrsvn( datadir, db_name, subcoll_name, svnroot(s) )\n";
    }
    my ($datadir, $db_name, $subcoll_name, $svnroots_par) = @_;

    my @svnroots;
    if (ref $svnroots_par) {
        @svnroots = @$svnroots_par;
    } else {
        @svnroots = ($svnroots_par);
    }

    if (not -e $datadir) {
        mkdir $datadir or die "can't make data directory $datadir: $!\n";
    }
    foreach my $svnroot (@svnroots) {
        my $dirname = getdirname( $svnroot );
        my $checkoutdir = "$datadir/$dirname";
        if (not -e $checkoutdir) {
            log_info "initial checkout of $svnroot into $checkoutdir";
            system ("$svn_prog checkout --username solr --password $solr_password --force --non-interactive $svnroot $checkoutdir") == 0 
                or die "$svn_prog checkout failed, aborting ($?)\n";
        }
    }

    chdir $datadir or die "can't chdir to $datadir: $!\n";

    init_solr($db_name);

    my $solr_only;
    GetOptions('n' => \$solr_only);

    if (@ARGV > 0) {
	    printf STDERR "Unknown arguments: @ARGV\n";
	    exit 255;
    }



    # Traverse desired filesystems
    foreach my $svnroot (@svnroots) {
        my $dirname = getdirname( $svnroot );
        my $checkoutdir = "$datadir/$dirname";
        if (!$solr_only) {
            system ("$svn_prog cleanup --username solr --password $solr_password --non-interactive $checkoutdir") == 0 
                or warn "cleanup failed ($?)\n";
	        system ("$svn_prog update --username solr --password $solr_password --force --non-interactive $checkoutdir") == 0 
                or die "$svn_prog failed, aborting ($?)\n";
        } else {
	        log_info "solr Only, skipping svn update";
        }

        ($find_checkoutdir, $find_svnroot, $find_subcoll_name) = ($checkoutdir, $svnroot, $subcoll_name);
        File::Find::find({wanted => \&wanted, no_chdir => 1}, $checkoutdir);
    }
    commit_solr;
    close_solr;

    return 1;
}

sub get_svn_url {
    my ($dir) = @_;
    my $url;
    open my $fh, '-|', "svn info $dir" or die $!;
    while(<$fh>) {
        if (/URL:\s*(.*)$/) {
            $url = $1;
        }
    }
    close $fh;
    return $url;
}

sub wanted {
  my ($dev,$ino,$mode,$nlink,$uid,$gid, $rdev, $size, $atime, $mtime, $ctime);

    if ( (($dev,$ino,$mode,$nlink,$uid,$gid, $rdev, $size, $atime, $mtime,$ctime) = lstat($_)) && -f _ 
    		&& $File::Find::name !~ m#/\.svn/#)
    {
    	my $id = $File::Find::name;
	    $id =~ s#$find_checkoutdir/#$find_svnroot#;
	    
	    
    	send_to_solr($File::Find::name,  { 
    		"id" => $id, 
    		"mtime" => xmltime $mtime, 
    		"ctime" => xmltime $ctime, 
    		"timestamp" => xmltime time,
    		"subcoll" => $find_subcoll_name 
    	} );
    }
}

1;

