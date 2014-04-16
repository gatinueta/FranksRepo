use strict;
use warnings;
use 5.010;

use Data::Dumper;
my $ids = 0;

sub TIESCALAR {
    return bless { id => $ids++, value => bless { value => shift }, 'main' }, 'main';
}

sub FETCH {
    my $self = shift;

    return $self->{value};
}

sub STORE {
    my ($self, $value) = @_;
    say "STORE: ", Dumper($self, $value);
    $self->{value}->{value} = $value;
}

my $v = 1;

tie $v, 'main';
$v = 2;


say $v, Dumper $v;
$v++;
