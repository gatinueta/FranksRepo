use strict;
use warnings;
use 5.010;

use List::Util 'first'; 
sub isprime { 
    my $n = shift; 
    for (my $i=2; $i<=sqrt($n); $i++) { 
        return 0 if ($n%$i==0); 
    } 
    return 1; 
} 

say "the first prime is ", first { isprime $_ } (4, 10, 9, 7, 2,10,100);


