package Foo;

use Moose;
use MooseX::Method::Signatures;
use 5.010;

sub say {
    my $self = shift;
    say @_;
}

method morning (Str $name) {
    $self->say("Good morning ${name}!");
}

method greet (Str :$who, Str :$how, Str :$mark = '!') {
    $self->say("$how $who$mark");
}

package main;
use strict;
use warnings;

use Method::Signatures;

func get(Int $i) {
    return "got $i";
}

my $foo = Foo->new();
$foo->morning( 'Frank' );
$foo->greet( who => 'Mary', how => 'Good day' );
$foo->greet( who => 'Jane', how => 'Howdy', mark => '.');

say get(100), get();
