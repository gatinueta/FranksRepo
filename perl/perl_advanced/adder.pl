package Adder;
use Moose;
use MooseX::Method::Signatures;

use 5.010;

has 'n' => (isa => 'Num', is => 'rw');

method add (Int $m) {
    return $self->n() + $m;
}

package main;
use strict;
use warnings;
use 5.010;

sub closure_adder {
    my ($n) = @_;
    return sub {
        my ($m) = @_;

        return $n+$m;
    }
}


my $adder = Adder->new( n => 100 );

say $adder->add(10);

my $adder2 = closure_adder(100);

say $adder2->(10);

