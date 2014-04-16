use strict;
use warnings;
use 5.010;

sub f {
    use Data::Dumper;
    print Dumper(\%^H);
}

sub g {
    say 'in g: ', @_;
}

use Data::Dumper;

$main::{'f'} = \&g;
print Dumper \%main::;
f(100);

