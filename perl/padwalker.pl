#!/usr/bin/env perl
use strict;
use warnings; 

use PadWalker;

my $a = 1;
open my $fh, '<', \$a;

my $h = PadWalker::peek_my(0);

use Data::Dumper;
print Dumper($h);

