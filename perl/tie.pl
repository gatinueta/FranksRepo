package F;
use strict;
use 5.010;
use Data::Dumper;

use overload 
    '+' => sub { say "+: ", Dumper \@_; };

sub TIESCALAR {
    my ($class, $value) = @_;
    say "tie to $class";
    return bless { value => $value }, $class;
}

sub FETCH {
    my $self = shift;
    say 'FETCH';
    $self->{fetches}++;
    return $self->{value};
}

sub STORE {
    my ($self, $value) = @_;
    say 'STORE: :', Dumper $self;
    $self->{value} = $value;
    $self->{stores}++;
}

sub stats {
    my $self = shift;
    return { fetches => $self->{fetches}, stores => $self->{stores} };
}

package main;

use Data::Dumper;

use strict;
use warnings;
use 5.010;

tie my $v, 'F';
tie my $w, 'F';

say $v++;
say $v+1;
$v = 100;
$v++;
say $v;

$w=1;
say tied ($v)+$w;

say Dumper $bi, tied $bi;

