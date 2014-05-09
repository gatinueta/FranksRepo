use GD;
use GD::Text::Wrap;
use Math::Trig;

use strict;

my $gd = GD::Image->new(800, 400); 

my $white = $gd->colorAllocate(255,255,255); # background color
my $black = $gd->colorAllocate(0,0,0);
my $green = $gd->colorAllocate(0, 255, 0);

my $text = "0123456789> +"; #"0100000090159>000000000000000000488153015+ 010699353>";

my ($ptsize, $angle, $x, $y) = (29.5, 0, 40, 90);

$gd->stringFT($green,'C:/windows/Fonts/pala.ttf',$ptsize, -&pi/4, $x*5, $y,
             "hi there\r\nbye now\nGlömmer",
             {linespacing=>0.8,
              charmap  => 'Unicode',
             }) or die "$@\n";

$gd->stringFT($black,'C:/Users/admin/devel/IDAutomationSOCRb.ttf',12,0, $x, $y*2,
             $text) or die "$@\n";

$gd->line($x, $y, $x, $y*2, $black);

binmode STDOUT;

print $gd->png();

