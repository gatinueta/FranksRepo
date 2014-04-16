use 5.010;
use warnings;
use strict;

sub f {
    my $a = 10;
    *b = \$a;
    $b++;
    say $a, $b;
    no strict 'vars';
    *CONSTANT = \10;
    say $CONSTANT;
}


f();
no strict 'vars'; 
say $b//'undef';

sub vivify {
    $_[0] = 1;
}

vivify(my $h);
say $h;

vivify(10);

