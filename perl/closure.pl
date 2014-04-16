use strict;
use warnings;
use 5.010;

sub get_adder {
    my $arg = shift;
    return sub { my $inner = shift; $arg + $inner; }
}

my $hadder = get_adder(100);
my $tadder = get_adder(1000);
say "hadder has ", $hadder->(20), ", but tadder has ", $tadder->(20);

sub get_id_from {
    my $id = shift;
    return sub {
        return $id++;
    }
}

my $get_next_10 = get_id_from(10);
my $get_next_100 = get_id_from(100);
foreach my $v (1..10) {
    say "1: ", $get_next_10->();
    if ($v % 2) {
        say "2: ", $get_next_100->();
    }
}



