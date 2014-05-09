package Point; 

use Class::Struct; 
use strict;
use warnings;

struct( x => q($), y => q($) ); 

use overload 
  q("") => \&as_string, 
  '+' => \&add,
  '*' => \&multiply;

sub as_string { 
  "[ " . $_[0]->x() . ", " . $_[0]->y() . " ] " 
}

sub add {
  my ($p1, $p2) = @_;
  my $p = new Point( 
    x => $p1->x() + $p2->x(),
    y => $p1->y() + $p2->y()
  );

  return $p;
}

sub multiply {
  my ($a1, $a2, $reverse) = @_;

  if (ref $a2 and $a2->isa(__PACKAGE__)) {
    return $a1->x * $a2->x + $a1->y * $a2->y;
  } else {
    my $p = new Point(
      x => $a1->x() * $a2,
      y => $a1->y() * $a2
    );

    return $p;
  }
}


package main; 

my $p = new Point( x => 10, y => 20 ); 
$p->x($p->x+1); 

print "$p twice is ", 2 * $p, "\n";

my $q = $p * 2;

print "$p * $q == ", ($p * $q), "\n";


