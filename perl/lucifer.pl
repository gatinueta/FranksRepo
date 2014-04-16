use 5.010;
use strict;
use warnings;

use Getopt::Long;

my $explain = 0;

GetOptions( 'explain' => \$explain );

sub explain {
    say @_ if ($explain);
}

#prime factors for $n
sub factor {
    my $n = shift;
    my @factors = ();
    use integer; 
    while($n>1) {
        T: for my $i (2..$n) {
            if ($n%$i==0) {
                push @factors, $i;
                $n /= $i;
                last T;
            }
        }
    }
    return @factors;
}

use Data::Dumper;

sub prettyprint {
    return join ', ', map { join '*', @$_; } @_;
}

sub product {
    my $n = 1;

    foreach (@_) {
        $n *= $_;
    }

    return $n;
}

# returns all possible factorizations with 2 distinct numbers between 1 and 100.
sub factors {
    my $n = $_[0];
    state %factor_cache;
    if ($factor_cache{$n}) {
        return @{$factor_cache{$n}};
    }
    my @p = factor($n);
    my %products;
    my $len = scalar @p;
    for my $s (0 .. (1<<$len)-1) {
        my @arr = split //, sprintf "%0${len}b", $s;
        my @set = ();
        for my $i (0..$#arr) {
            push @set, $p[$i] if ($arr[$i] eq '1');
        }
        my ($a,$b) = (product(@set), $n/product(@set));
        if ($a<100 and $b<100 and $a>1 and $b>1 and $a!=$b) {
            ($b, $a) = ($a, $b) if ($a > $b);
            $products{$a} = $b;
        }
    }
    my @facts = ();
    while (my ($a, $b) = each %products) {
       push @facts, [$a, $b]; 
    }
    $factor_cache{$n} = \@facts;
    return @facts;
}

# returns all possible sums with 2 distinct numbers between 1 and 100.
sub sums {
    my $n = shift;

    my @sums = ();
    use integer;
    for my $i (2..($n-1)/2) {
        push @sums, [$i, $n-$i];
    }
    return @sums;
}

# tests whether P knows given the product $p
sub P_knows {
    my $p = shift;

    if (scalar(factors($p)) == 1) {
        return 1;
    }
    return 0;
}

# tests whether S knows that P doesn't know, given the sum $s
sub S_knows_that_P_doesnt_know {
    my $s = shift;
    explain "test if P doesn't know $s";
    foreach my $sum (sums($s)) {
        if (P_knows(product(@$sum))) {
            explain "$s: forget ", join ('+', @$sum), ", P knows ", product(@$sum);
            return 0;
        }
    }
    explain "$s: P doesn't know"; 
    return 1;
}

# tests whether P knows only after he's being told that P doesn't know. If true, returns the factors.
sub P_knows_only_if_S_knows_that_p_doesnt_know {
    my $p = shift;

    return () if (P_knows($p));

    my @all_factors = factors($p);
    my @factors = grep { S_knows_that_P_doesnt_know($_->[0] + $_->[1]) } @all_factors;

    if (@factors == 1) {
        explain "$p: factors: ", prettyprint(@factors), ', all_factors: ', prettyprint(@all_factors);
        return @{$factors[0]};
    }
    return (); 
}

my %solutions;

# calculate all possible solutions for P
for my $p (2*3..98*99) {
    next if (factors($p) == 0);
    if (my @factors = P_knows_only_if_S_knows_that_p_doesnt_know($p)) {
        my $sum = $factors[0]+$factors[1]; 
        say "$p: ", join ('*', @factors), " (Sum $sum)";
        $solutions{$sum}++;
    }
}

# which of these solutions have a unique sum?
foreach my $key (keys %solutions) {
    my $nof_solutions = $solutions{$key};
    say "there are $nof_solutions solutions for P with a sum of $key";
    say "POSSIBLE SOLUTION: $key" if $nof_solutions==1;
}

