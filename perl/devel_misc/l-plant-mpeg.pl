use Data::Dumper;
use FfmpegEncode;

use strict;

sub bham ($$$$$$) {
  my ($setpixel, $xstart, $ystart, $xend, $yend, $color) = @_;
  
#/*--------------------------------------------------------------
# * Bresenham-Algorithmus: Linien auf Rastergeräten zeichnen
# *
# * Eingabeparameter:
# *    int $xstart, $ystart        = Koordinaten des Startpunkts
# *    int $xend, $yend            = Koordinaten des Endpunkts
# *    function $setpixel
#      $color
# * Ausgabe:
# *    $setpixel($x, $y, $color) setze ein Pixel in der Grafik auf $color
# *         (wird in dieser oder aehnlicher Form vorausgesetzt)
# *---------------------------------------------------------------
# */
#{
  use integer;
 
#/* Entfernung in beiden Dimensionen berechnen */
   my $dx = $xend - $xstart;
   my $dy = $yend - $ystart;
 
#/* Vorzeichen des Inkrements bestimmen */
  my $incx = $dx <=> 0;
  my $incy = $dy <=> 0;
  if($dx<0) {$dx = -$dx; }
  if($dy<0) {$dy = -$dy; }
 
#/* feststellen, welche Entfernung größer ist */
  my ($pdx, $pdy, $ddx, $ddy, $es, $el);
  if ($dx>$dy) {
     #/* x ist schnelle Richtung */
      $pdx=$incx; $pdy=0;    #/* pd. ist Parallelschritt */
      $ddx=$incx; $ddy=$incy; #/* dd. ist Diagonalschritt */
      $es =$dy;   $el =$dx;   #/* Fehlerschritte schnell, langsam */
   } else {
     #/* y ist schnelle Richtung */
      $pdx=0;    $pdy=$incy; #/* pd. ist Parallelschritt */
      $ddx=$incx; $ddy=$incy;# /* dd. ist Diagonalschritt */
      $es =$dx;   $el =$dy;  # /* Fehlerschritte schnell, langsam */
   }
 
#/* Initialisierungen vor Schleifenbeginn */
   my $x = $xstart;
   my $y = $ystart;
   my $err = $el/2;
 
#/* Pixel berechnen */
   for(my $t=0; $t<$el; ++$t) #/* t zaehlt die Pixel, el ist auch Anzahl */
   {
     #     /* Aktualisierung Fehlerterm */
      $err -= $es; 
      if($err<0)
      {
        #    /* Fehlerterm wieder positiv (>=0) machen */
          $err += $el;
          # /* Schritt in langsame Richtung, Diagonalschritt */
          $x += $ddx;
          $y += $ddy;
      } else
      {
        #/* Schritt in schnelle Richtung, Parallelschritt */
          $x += $pdx;
          $y += $pdy;
      }
    &$setpixel($x, $y, $color);
   }
} #/* gbham() */

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

my $black = pack "CCC", 0, 0, 0;

my $canvas = $black x (PIXWIDTH * PIXHEIGHT);

FfmpegEncode::open_codec( PIXWIDTH, PIXHEIGHT ) or die "can't open codec\n";

my $rgb_image = FfmpegEncode::allocate_rgb_image();
my $encoding_buf = "";

my $fh;
my $filename = "l-plant.mpeg";

open $fh, ">$filename" or die "can't open $filename: $!\n";

sub forward {
  my ($pos, $angle_deg) = @_;

  my $angle_rad = $angle_deg*2*PI/360;

  my $newxpos = $pos->[0]+LENGTH*sin($angle_rad);
  my $newypos = $pos->[1]+LENGTH*cos($angle_rad);

  return [$newxpos, $newypos];
}

sub update {
  FfmpegEncode::set_rgb_data( $rgb_image, $canvas );
  my $size = FfmpegEncode::encode_rgb_frame($rgb_image, \$encoding_buf);

  syswrite $fh, $encoding_buf, $size;
}

sub rangecheck {
  my ($x, $y ) = @_;
  
  return 0 if ($x < 0 or $x > PIXWIDTH-1);
  return 0 if ($y < 0 or $y > PIXHEIGHT-1);
  
  return 1;
}

my @lines = ();
my $cur_iter = 0;

my %drawn_pixels = ();

sub setpixel($$$) {
  my ($x, $y, $color) = @_;

  my $offset = 3*($y*PIXWIDTH+$x);
  substr($canvas, $offset, 3) = pack "CCC", $color->[0], $color->[1], $color->[2];

  foreach my $tag (@{$color->[3]}) {
    if (!exists($drawn_pixels{$tag})) {
      $drawn_pixels{$tag} = [];
    }
    push @{$drawn_pixels{$tag}}, [$x, $y];
  }
}

sub drawline {
  my ($startpos, $endpos, $color) = @_;

  if (rangecheck(@$startpos, @$endpos)) {
    bham( \&setpixel, int $startpos->[0], PIXHEIGHT - int $startpos->[1], int $endpos->[0], PIXHEIGHT - int $endpos->[1], $color);
  }
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
    if ($counter++ % 100 == 0) { update(); }
  }
  @str = @newstr;

  print "\@str is ", scalar @str, " long\n";
  
  my @states = ();
  my $color = [ rand(256), int rand(256), int rand(256), [ "i $cur_iter" ] ];
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
    if ($counter++ % 100 == 0) { update(); }
  }
  print "drew \@str\n";

  foreach my $iter (0.. $cur_iter-3) {
    if (exists($drawn_pixels{"i $iter"})) {
      my @arr = @{$drawn_pixels{"i $iter"}};
      my @newarr = ();
      foreach my $item (@arr) {
        if (rand()<probability($cur_iter-$iter)) { 
          setpixel($item->[0], $item->[1], [0,0,0,[]]);
        } else {
          push @newarr, $item;
        }
        if ($counter++ % 100 == 0) { update(); }
      }
      $drawn_pixels{"i $iter"} = \@newarr;
    }
  }
}

#sub move {
#  foreach my $iter (0..$cur_iter-1) {
#    $canvas->move("i $iter", 0, -10);
#  }
#  print "moved\n";
#  $mw->after(MOVE_DELAY, \&move, $canvas);
#}

for (my $it=0; $it<27; $it++) {
  print "iteration $it\n";
  iterate();
}

while (1) {
  my $size = FfmpegEncode::encode_rgb_frame(undef, \$encoding_buf);
  last if ($size == 0);
  syswrite $fh, $encoding_buf, $size;
}

FfmpegEncode::write_mpeg_footer($fh);

close $fh;

# move();

