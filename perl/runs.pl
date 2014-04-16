use strict;
use warnings;
use 5.010;

my $last_wxy = '';
my @run = ();
my $finished;

while(defined(my $line = <DATA>) or !$finished++) {
    my ($wxy, $z) = ($line =~ /(.*),(\d+)/);
    if (!defined($wxy) or $wxy ne $last_wxy) {
        say "$last_wxy,", join ('-', @run) if (@run);
        @run = ();
    }
    push @run, $z if (defined($z));
    $last_wxy = $wxy if (defined($wxy));
}

__DATA__
10,1,100,3
10,2,1,20
10,2,1,90
10,2,1,110
40,2,1,4
40,2,1,10
40,2,1,100
40,2,2,0
50,100,0,0
50,100,0,1
50,100,0,2
50,100,0,10
50,100,1,4
