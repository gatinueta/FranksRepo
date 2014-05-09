#!/usr/bin/perl -w

use strict;
use warnings;
use constant MAXD => 11;
use Tk;
use Data::Dumper;

package GridElem;
use Class::Struct;
struct( x => '$', y => '$', val => '$', label => '$', overflow => '$', lastmod => '$' );

sub getcolor($) {
  if ($_[0]>0) {
    return "green";
  } else {
    return "light blue";
  }
}

sub redraw {
  my $self = $_[0];
  use Data::Dumper;

  $self->label()->configure( -text => $self->val(), -background => getcolor($self->val()) );
}

sub setmarking {
  my $self = $_[0];

  $self->label()->configure( -background => "red" );
}

package main;

sub add(@) {
  my ($x1, $y1, $x2, $y2) = @_;

  my @res = (($x1+$x2)%MAXD, ($y1+$y2)%MAXD);

}

my $mw = new MainWindow( -title => "they taketh and they arth taken" );

$mw->configure( -width => 640, -height => 480 );

my @arr; 
foreach my $y (0..MAXD-1) { 
  foreach my $x (0 .. MAXD-1) {
    my $value = int (rand 100) - 50;
    my $label = $mw->Label(-text => $value, -background => GridElem::getcolor($value), -width => 5);
    $label->grid( -row => $x, -column => $y );
    my $ge = new GridElem ( x => $x, y => $y, val => $value, label => $label, lastmod => 0 );
    push @arr, $ge; 
  }
} 

sub gridelem(@) {
  my ($x, $y) = @_;

  if (0 <= $x and $x < MAXD and 0 <= $y and $y < MAXD) {
    return $arr[$x+$y*MAXD];
  } else {
    return undef;
  }
}

#print Dumper(@arr);

use constant P_MARK => 1;
use constant P_SWEEP => 2;
use constant P_PUNISH => 3;

my $modo_state = P_MARK;

my %next_state = (
  &P_MARK => P_SWEEP,
  &P_SWEEP => P_PUNISH,
  &P_PUNISH => P_MARK
);

map { print join ", ", $_; } (each %next_state);
sub next_state {
  $modo_state = $next_state{$modo_state};
}

my @pos = (int (MAXD/2), int (MAXD/2));
my @nextpos;
my $minlastmod;
my $maxnewval;
my $counter = 0;

my @mov = ( [-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1] );

sub modo {
    my $curelem = gridelem(@pos);

    if ($modo_state == P_MARK) {
      $counter++;
      $curelem->setmarking();
      $curelem->lastmod($counter);
    }
    elsif ($modo_state == P_SWEEP) {
      $minlastmod = 100000;
      $maxnewval = -1000;
      foreach my $move (@mov) {    
        my @nbpos = add(@pos, @{$move});
        my $neighbor = gridelem(@nbpos);
        if (defined($neighbor)) {
          }

          if ($neighbor->val > $maxnewval) {
            $maxnewval = $neighbor->val;
            @nextpos = @nbpos;
          }

          if ($neighbor->val()>0 ) {
            $neighbor->val($neighbor->val-1);
            $neighbor->redraw;

            $curelem->val($curelem->val+1);
          }
        }

        if ($curelem->val > $maxnewval) {
          $curelem->overflow(1);
        }
      
      $curelem->redraw;
    }
    elsif ($modo_state == P_PUNISH) {
      if ($curelem->overflow) {
        my $minval = 1000;
        my $leastelem;
        foreach my $move (@mov) {
          my $otherelem = gridelem( add(@pos, @$move) );
          if (defined($otherelem) and  $otherelem->val < $minval) {
            $minval = $otherelem->val;
            $leastelem = $otherelem;
          }
        }
        my $tmpval = $curelem->val;
        $curelem->val($leastelem->val);
        $leastelem->val($tmpval);

        $leastelem->redraw;
        $curelem->overflow(0);
        $curelem->redraw;
      }

      if ($maxnewval != -1000) {
        @pos = @nextpos;
      }
    }
    next_state;
}

$mw->repeat(120, \&modo);
MainLoop;

