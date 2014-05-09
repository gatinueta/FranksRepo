use GD;
use GD::Text::Wrap;
use Math::Trig;

use strict;

use constant MM_PER_INCH => 25.4;
use constant RESOLUTION_DPI => 200;

use constant INCH_FRACT_WIDTH => 10;
use constant INCH_FRACT_HEIGHT => 6;

use constant SLIP_WIDTH_INCH => 59.0/INCH_FRACT_WIDTH;
use constant SLIP_HEIGHT_INCH => 25.0/INCH_FRACT_HEIGHT;

my $gd;

sub draw_codeline {
  my ($black,$ocrb_font,$ptsize,$angle, $x, $y, $text) = @_;

  my $res = 1;

  for my $char (split //, $text) {
    $res = $gd->stringFT($black,$ocrb_font,$ptsize,0, $x, $y, $char);
    return $res if (!$res);
    $x += RESOLUTION_DPI/INCH_FRACT_WIDTH;
  }
  return $res;
}


$gd = GD::Image->new(SLIP_WIDTH_INCH*RESOLUTION_DPI+1, SLIP_HEIGHT_INCH*RESOLUTION_DPI+1);

my $POSR_KZ = SLIP_WIDTH_INCH-3.0/10;
my $POSO_KZ21 = SLIP_HEIGHT_INCH-5.0/6;
my $POSO_KZ23 = SLIP_HEIGHT_INCH-3.0/6;

my $white = $gd->colorAllocate(255,255,255); # background color
my $black = $gd->colorAllocate(0,0,0);
my $green = $gd->colorAllocate(0, 255, 0);

my $text21 = "010699353>";
my $text23 = "0100000090159>000000000000000000488153015+ 010699353>";

my $ocrb_font = "C:/WINDOWS/Fonts/TT0646Z.TTF";

$gd->rectangle(0, 0, SLIP_WIDTH_INCH*RESOLUTION_DPI, SLIP_HEIGHT_INCH*RESOLUTION_DPI, $black);

my ($ptsize, $angle, $x21, $x23, $y21, $y23) = (20, 0, 
  RESOLUTION_DPI*($POSR_KZ-length($text21)/10), 
  RESOLUTION_DPI*($POSR_KZ-length($text23)/10), 
  RESOLUTION_DPI*$POSO_KZ21, RESOLUTION_DPI*$POSO_KZ23);

draw_codeline($black,$ocrb_font,$ptsize,0, $x21, $y21,
             $text21) or die "$@\n";

draw_codeline($black,$ocrb_font,$ptsize,0, $x23, $y23,
             $text23) or die "$@\n";

binmode STDOUT;

print $gd->png();

