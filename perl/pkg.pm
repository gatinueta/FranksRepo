package pkg;
use strict;
use warnings;
use 5.010;
use base 'Exporter';
our @EXPORT_OK = 'afunc';

sub afunc {
    say 'pkg::afunc called.';
}

1;

