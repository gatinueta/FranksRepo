
use strict; 

my $max = shift || 101;
my @c = (); 

sub pushit {
  if (defined($_[0])) {
    push @{$_[0]}, $_[1];
  } else {
    $_[0] = [ $_[1] ];
  }
}

for (my $i=2; $i<=$max/2;$i++) { 
  if (!$c[$i]) { 
    for (my $f=2; $f*$i<=$max; $f++) { 
      pushit ($c[$i*$f], $i); 
    } 
  } 
} 

for (my $i=2; $i<=$max; $i++) { 
  if ($c[$i]) {
    print "$i: @{$c[$i]}\n";
  } else {
    print "$i: prime\n";
  }
}

