use strict;
use warnings;
use 5.010;

my $max = shift;
my @f;

foreach my $n (2..$max) {
    my $m=2;
    unless ($f[$m]) {
        while ($n*$m < $max) {
            $f[$n*$m]++;
            $m++;
        }
    }
}

my $p=2;
my $c=0;
while($p < @f) {
    unless ($f[$p]) {
        $c++;
        say "$c: $p";
        if ($c == 10001) {
            say $p;
            last;
        }
    }
    $p++;
}
