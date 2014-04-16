use 5.010;
use strict;
use warnings;

package F;

sub TIESCALAR {
    my $class = shift;
    bless { value => bless {}, 'main' }, $class;
}

sub FETCH {
    my ($self) = shift;
    say 'FETCH';
    return $self->{value};
}

use overload 
    '+' => sub { say 'F::add'; },
    '0+' => sub { say 'F::tonum'; };

package main;

use overload 
    '+' => sub { say 'main::add'; },
    '0+' => sub { say 'main::tonum'; };

my $a = bless {}, 'F';
tie $a, 'F';

say "a + 10 = ", $a+10;
say "a + 10 = ", $a+10;
say "the value of a is $a";
say "a + 10 = ", $a+10;
say "a is a ", ref $a;
say "a is tied to a ", ref tied $a;

