use strict;
use warnings;
use 5.010;

package F;

sub TIESCALAR {
    return 27;
}

sub FETCH {
    say 'FETCH';
}

package main;

use overload 
    '+' => sub { 
        my ($self, $other) = @_;
        return $self->{value} . $other;
    },
    '0+' => sub {
        my $self = shift;
        return $self;
    };

my $vr = bless { value => 3 }, 'main';

say $vr + 1;

tie $vr, 'F';
use Data::Dumper;
say $vr;

$vr += 1;
say Dumper $vr;
say $vr + 1;

