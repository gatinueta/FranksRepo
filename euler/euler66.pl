use strict;
use warnings;
use 5.010;
use integer;
sub issquare {
    my $n = shift;

    my $r = int(sqrt($n)+.5);
    return $r*$r == $n;
}
my %largeD = ();
my ($maxX, $maxD) = (0);

sub sqrt_cached {
    state @s;
    my $n = shift;

    return $s[$n] if ($s[$n]);
    $s[$n] = sqrt($n);
    return $s[$n];
}

DLOOP: foreach my $D (1..1000) {
    next if issquare($D); 
    XLOOP: for (my $x=2; ; $x++) {
        my $arg = ($x*$x-1)/$D;
        my $y = int sqrt_cached($arg);
        my $res;
        while (($res = $x*$x - $D * $y * $y)>1) { $y--; }
        if ($res==1) { 
            say "$x^2 - $D * $y^2 = $res";
            $maxX = $x, $maxD = $D if ($x > $maxX);
            next DLOOP;
        } else {
            #say "$x^2 - $D * $y^2 = $res";
        }
    }
}
say "$maxD, $maxX";


