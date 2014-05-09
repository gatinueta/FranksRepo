use strict; 
my $s = 'blurchiarghiabcsiboordctrailcx'; 
if (my ($prematch, $ab, $bc, $postmatch ) = 
    $s =~ m{
        \A 
        (.*) a (.*) b (.*) c (.*) 
        \z
        }xms
    ) 
{
    print "($prematch)a($ab)b($bc)c($postmatch)\n";
}

