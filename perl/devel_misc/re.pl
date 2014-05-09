use strict;

use re 'debug';

my $string = shift;
my ($before, $number, $after) = 
    $string =~ m{
        \A           # beginning of string
        (.*?)        # anything, ungreedy
        [ ]          # a space
        (\d+)        # a couple of numbers
        (.*)         # anything
        \z           # end of string
    }xms;

if ($number) {
    print "before=$before, number=$number, after=$after\n";
}




