use Data::Dumper;
use strict;

my %rules = ( 
  "X" => [ split //, "F-[[X]+X]+F[+FX]-X" ], 
#   "Y" => [ split //, "[F--F++F]" ], 
#  "X" => [ split //, "F-[[YX]+XY]+F[+FX]-XY" ], 

  "F" =>  [ split //, "FF" ],
);

use constant STARTSTR => "X";


use constant LENGTH => 3;
use constant PI => 3.14159;

use constant PIXWIDTH => 600;
use constant PIXHEIGHT => 800;

use constant ANGLEINC => 25;

use constant MOVE_DELAY => 200;
use constant ITER_DELAY => 3000;

use Tk;

my $mw = MainWindow->new();
$mw->title("L-System Plant");

my $canvas = $mw->Canvas(
  -width => PIXWIDTH, -height => PIXHEIGHT, -background => "white"
)->pack(-expand => 1, -fill => "both");


sub forward {
  my ($pos, $angle_deg) = @_;

  my $angle_rad = $angle_deg*2*PI/360;

  my $newxpos = $pos->[0]+LENGTH*sin($angle_rad);
  my $newypos = $pos->[1]+LENGTH*cos($angle_rad);

  return [$newxpos, $newypos];
}


sub rangecheck {
  foreach (@_) {
    return 0 if ($_ < 0 or $_ > PIXWIDTH*2-1);
  }
  return 1;
}

my @lines = ();
my $cur_iter = 0;

sub drawline {
  my ($startpos, $endpos, $color) = @_;

  if (rangecheck(@$startpos, @$endpos)) {
    
     $canvas->createLine(int $startpos->[0], PIXHEIGHT - int $startpos->[1], int $endpos->[0], PIXHEIGHT - int $endpos->[1], -width => 1, -fill => $color,
      -tags => [ "i $cur_iter" ]);
    #print Dumper $item;
  }
  #print Dumper($startpos, $endpos);
}

my @str = split //, STARTSTR;

sub probability {
  my $x = shift;

  return $x/4-3/4;
}

sub iterate {
  my $angle_deg = 0;
  my $pos = [rand()*PIXWIDTH,0];

  $cur_iter++;

  if ($cur_iter % 8 == 0) {
    @str = split //, STARTSTR;
  }

  my $counter = 0;
  my @newstr = ();
  foreach (@str) {
    my $prod = $rules{$_};
    if ($prod) {
      push @newstr, @$prod;
    } else {
      push @newstr, $_;
    }
    if ($counter++ % 100 == 0) { $mw->update(); }
  }
  @str = @newstr;

  print "\@str is ", scalar @str, " long\n";
  
  my @states = ();
  my $color = sprintf( "#%02x%02x%02x", int rand(256), int rand(256), int rand(256) );
  foreach my $in (@str) {
    if ($in eq "F") {
      my $endpos = forward($pos, $angle_deg);
      drawline($pos, $endpos, $color);
      $pos = $endpos;
    } elsif ($in eq "[") {
      push @states, [$pos, $angle_deg];
    } elsif ($in eq "]") {
      my $state = pop @states;

      ($pos, $angle_deg) = @$state;
    } elsif ($in eq "+") {
      $angle_deg += ANGLEINC * (2*rand()-1);
    } elsif ($in eq "-") {
      $angle_deg -= ANGLEINC * (2*rand()-1);
    } elsif ($in eq "X") {
    }
    if ($counter++ % 100 == 0) { $mw->update(); }
  }
  print "drew \@str\n";

  foreach my $iter (0.. $cur_iter-3) {
      my @arr = $canvas->find("withtag",  "i $iter");
      foreach my $item (@arr) {
        if (rand()<probability($cur_iter-$iter)) {
          $canvas->delete($item);
        } else {
          $canvas->move($item, -2, 0);
        }
        if ($counter++ % 100 == 0) { $mw->update(); }
      }
  }

  
#  if ($cur_iter > 10) {
#    $canvas->delete("i " . ($cur_iter-10));
#  }
  $mw->after(ITER_DELAY, \&iterate, $canvas);

}

sub move {
  foreach my $iter (0..$cur_iter-1) {
    $canvas->move("i $iter", 0, -10);
  }
  print "moved\n";
  $mw->after(MOVE_DELAY, \&move, $canvas);
}


iterate();
# move();


$mw->MainLoop();
