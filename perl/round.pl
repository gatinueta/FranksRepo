use strict;
use warnings;
use 5.010;
use Math::BigFloat;

use bignum;

sub get_millis {
    my $v = shift;
    $v = Math::BigFloat->new($v)->bdiv(100);

    return $v->bmul(1000)->bmod(1000);
}

sub get_bignum_millis {
    my $v = shift;
    $v/=100;

    return ($v*1000)%1000;
}

sub get_raw_millis {
    no bignum;
    my $v = shift;
    $v/=100;

    return ($v*1000)%1000;
}

while(1) { 
    my $r  = int(rand(1000000)); 
    my $t  = get_raw_millis($r);
    my $ct = get_millis($r);
    my $bt = get_bignum_millis($r);
    say "$r: $t, $bt ($ct)" if ($t%10 != 0);
}

