#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use GD;
use Math::Trig;

sub oor {
    my $v = shift;

    return $v < 0 or $v > 255;
}

# create a new image
my ($width, $height) = (500, 500);
my $im = new GD::Image($width, $height,1);

sub getcolor1 {
    my ($r,$g,$b) = @_;

    return $im->colorResolve($r,$g,$b);
}

sub getcolor {
    state %cat;
    my ($r,$g,$b,$a) = @_;
    my $cached_color = $cat{"$r,$g,$b,$a"};
    return $cached_color if defined $cached_color;

    $cached_color = $im->colorAllocateAlpha($r,$g,$b,$a);
    if ($cached_color >= 0) {
        $cat{"$r,$g,$b,$a"} = $cached_color;
    }
    return $cached_color;
}

# allocate some colors
my $white = getcolor(255,255,255,0);
my $black = getcolor(0,0,0,0);

# make the background transparent and interlaced
$im->transparent($white);
$im->interlaced('true');

foreach my $x (0..$width-1) {
    foreach my $y (0..$height-1) {
        my $sinx =  sin(2*pi/$width*($x-$width/2));
        my $sum =   sin(2*pi/($width+$height)*($x-$width+$y-$height)/2);
        my $siny =  sin(2*pi/$height*($y-$height/2));
        my $red =   abs (255-abs int(128.0*(1+$sinx)));
        my $blue =  abs (255-abs int(128.0*(1+$siny)));
        my $green = abs (255-abs int(128.0*(1+$sum )));
        my $alpha = int (128*(($x+$y)/($width+$height)));
        warn "oor: $x, $y, $red, $green, $blue" if (oor $red or oor $green or oor $blue);
#        quantify($red,$green,$blue);
        my $color = getcolor($red,$green,$blue, $alpha);
        $im->setPixel($x,$y,$color);
    }
}
open my $imgfile, '>', 'test.png';
# make sure we are writing to a binary stream
binmode $imgfile;

# Convert the image to PNG and print it on standard output
print $imgfile $im->png;

close $imgfile;

