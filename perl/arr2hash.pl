#!/usr/bin/perl

use strict;
use warnings;

my @arr = (
    { name => 'Frank', level => 2, quality => 3.2 },
    { name => 'God',   level => 1000, quality => undef },
    { name => 'other', level => undef, quality => 20 },
);

my %name2arr = map { $_->{name} => $_ } @arr;

use Data::Dumper;

print Dumper(\%name2arr);


