use strict;
use warnings;
use 5.010;

use Data::Dumper;
my @denom = qw(1 2 5 10 20 50 100 200);

sub sum {
    my ($start, $aim) = @_;
    if ($start >= @denom) {
        if ($aim==0) {
            return ([]);
        } else {
            return ();
        }
    }
    my $n=0;
    my @res = ();
    while((my $ts = $n*$denom[$start]) <= $aim) {
        my @m = sum($start+1, $aim-$ts);
        push @res, map { [ $n, @$_ ] } @m;

#        foreach my $lr (@m) {
#            push @res, [ $n, @$lr ];
#        }
        $n++;
    }
  #  say "start: $start, aim: $aim: ", Dumper(\@res);
    return @res;
}

my @arr = sum(0, 200);
foreach my $w (@arr) {
    say join ", ", map { "$w->[$_] x $denom[$_]p" } (0..$#denom);
}
#say Dumper(\@arr);
say scalar(@arr), " solutions.";


