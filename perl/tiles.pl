use strict;
use warnings;

my @tiles = ( 
    [ qw(r g b b) ],
    [ qw(g b r r) ],
    [ qw(r g b b) ],
    [ qw(g b r r) ],
    [ qw(r g b b) ],
    [ qw(g b r r) ],
    [ qw(r g b b) ],
    [ qw(g b r r) ],
    [ qw(r g b b) ],
);

my @directions = (
    qw(l t r b),
    qw(t r b l),
    qw(r b l t),
    qw(b l t r),
);

# positions: 

#   0 1 2
#   3 4 5
#   6 7 8

my @position_matches = ( 
    '0r-1l', '1r-2l', 
    '3r-4l', '4r-5l', 
    '6r-7l', '7r-8l', 
    '0b-3t', '3b-6t', 
    '1b-4t', '4b-7t', 
    '2b-5t', '5b-8t',
);

package TileConfig;

use Moose;

has 'tile' => ( is => 'rw', isa => 'Int');
has 'direction' => ( is => 'rw', isa => 'Int');
has 'position' => ( is => 'rw', isa => 'Int' );

package main;


my $tile_config = new TileConfig(tile => $tiles[$i], direction => $direction )  

