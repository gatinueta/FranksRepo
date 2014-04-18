#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

use GD;
use Math::Trig;

# create a new image
my ($width, $height) = (300, 300);
my $im = new GD::Image($width, $height);

# allocate some colors
my $white = $im->colorAllocate(255,255,255);
my $black = $im->colorAllocate(0,0,0);

# make the background transparent and interlaced
$im->transparent($white);
$im->interlaced('true');

foreach my $x (0..$width-1) {
    foreach my $y (0..$height-1) {
        my $sinx = sin(2*pi/$width*($x-$width/2));
        my $sum =  sin(2*pi/($width+$height)*(($x-$width+$y-$height)/2));
        my $siny = sin(2*pi/$height*($y-$height/2));
        my $red = 255-abs int(128.0*$sinx);
        my $green = 255-abs int(128.0*$siny);
        my $blue = 255- abs int(128.0*$sum);
        my $color = $im->colorResolve($red, $green, $blue);
        $im->setPixel($x,$y,$color) if (1);
    }
}

# make sure we are writing to a binary stream
binmode STDOUT;

# Convert the image to PNG and print it on standard output
print $im->png;

