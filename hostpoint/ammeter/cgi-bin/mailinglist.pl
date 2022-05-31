#!/usr/bin/perl -w
use FindBin;
use lib "$FindBin::RealBin/modules";
use Mail_POP3Client;

$docbase = "/export/web26/alpha/ammete/parsek/";
$listfile = "$docbase/sendflyers.list.txt";
$pop_username = "17060.parsekflyers";
$pop_password = "blurx";

$SIG{__DIE__} = sub { 
  my $error = shift; 
  print "ERROR: ", $error, "\n"; 
};

sub getoldmembers {
  my @oldmembers = ();

  open LIST, "<$listfile" or die "can't open $listfile: $!";
  
  while (<LIST>) {
    if (/(\S+@\S+)/) {
      push @oldmembers, $1;
    }
  }
  close LIST;
  return @oldmembers;
}
sub getnewmembers {
  my @newmembers = ();
  my $pop = new Mail::POP3Client( USER      => $pop_username,
			          PASSWORD  => $pop_password,
			          HOST      => "mail.ammeter.ch",
			          AUTH_MODE => "PASS",
  );

  my $i;

  foreach $i ( 1 .. $pop->Count() ) {
    foreach( $pop->Body( $i ) ) {
      push @newmembers, $1 if (/^e-mail=(.*@.+?)\s*$/);
    }   
  }
  $pop->Close();
  return @newmembers;
}

sub getallmembers {
  my @oldmembers = getoldmembers;
  my @newmembers = getnewmembers;
  
  my %allmembers = ();
  foreach( @oldmembers ) {
    $allmembers{$_} = 1;
  }
  my @reallynewmembers = ();
  foreach ( @newmembers ) {
    unless ($allmembers{$_}) {
      push @reallynewmembers, $_;
      $allmembers{$_} = 1;
    }
  }
  return ( [ keys %allmembers ], \@reallynewmembers );
}

sub deletenewmembers {
  my %delmembers = ();
  while ($_=shift) {
    $delmembers{$_} = 1;
  }

  my $pop = new Mail::POP3Client( USER      => $pop_username,
			          PASSWORD  => $pop_password,
			          HOST      => "mail.ammeter.ch",
			          AUTH_MODE => "PASS",
  );

  my $i;

  foreach $i ( 1 .. $pop->Count() ) {
    foreach( $pop->Body( $i ) ) {
      if (/^e-mail=(.*@.+?)\s*$/) {
	if ($delmembers{$1}==1) {
	  print "deleting $1...\n";
	  $pop->Delete( $i );
	} else {
	  print "$1 unknown, not deleted!\n";
	}
      }   
    }
  }
  $pop->Close();
}

sub storeallmembers {
  print "storing new member list in $listfile ...\n ";
  open LIST, ">$listfile.new" or die "can't open $listfile.new: $!";
  
  print LIST join "\n", @_;
  print LIST "\n";
  close LIST;
  
  use File::Copy;
  copy $listfile, "$listfile.old" or 
    die "can't copy $listfile to $listfile.old: $!";
  rename "$listfile.new", $listfile or 
    die "can't rename $listfile.new to $listfile: $!";
}

print "Content-Type: text/plain\n\n";

print "checking for new members ...\n";
($allmembers_ref, $newmembers_ref) = getallmembers;
@allmembers = @$allmembers_ref;
@newmembers = @$newmembers_ref;

if (@newmembers) {
  print "new members: ", join (" ", @newmembers), "\n";
  storeallmembers @allmembers;
} else {
  print "no new members.\n";
}

deletenewmembers @allmembers;

print "done.\n";
