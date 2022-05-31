#!/usr/bin/perl -w

use CGI qw/:standard/;

$docbase = "/export/web26/alpha/ammete/parsek";
$listfile = "$docbase/sendflyers.list.txt";

$SIG{__DIE__} = sub { 
  my $error = shift; 
  print h1 ( "ERROR: ", $error );
  print end_html;
};

sub getoldmembers {
  my @oldmembers = ();

  open LIST, "<$listfile" or die "can't open $listfile: $!";
  
  while (<LIST>) {
    chomp;
    if (/(\S+@\S+)/) {
      push @oldmembers, $_;
    }
  }
  close LIST;
  return @oldmembers;
}

sub strip {
  $_[0] =~ s/\s+//g;
}

sub getnewmember {
  my $firstname = param('name') or die "first name missing";
  my $lastname = param('surname') or die "surname missing";
  my $email = param('e-mail') or die "e-mail missing";
  
  strip $email;
  strip $firstname;
  strip $lastname;
  $email =~ /\S+@\S+\.\S+/ or die "bad e-mail format";
  $firstname =~ /\w/ && $lastname =~ /\w/ or die "bad name format";
  $newmember = qq/"$firstname $lastname" <$email>/;
  return $newmember;
}

sub getallmembers {
  my @oldmembers = getoldmembers;
  my @newmembers = getnewmember;
  
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

sub storeallmembers {
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

print header, start_html( -bgcolor=>"#000000",
			  -text   =>"#FFFFFF",
			  -link   =>"#0000FF",
			  -vlink  =>"#551A8B",
			  -alink  =>"#0000FF",
			  -title => "added to mailing list"), 
  "\n";

($allmembers_ref, $newmembers_ref) = getallmembers;
@allmembers = @$allmembers_ref;
@newmembers = @$newmembers_ref;

if (@newmembers) {
  storeallmembers @allmembers;
  print h1("you have been added to the mailing list");
} else {
  print h1("you already are on the mailing list");
}
print end_html;
