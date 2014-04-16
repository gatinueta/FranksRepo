use Method::Signatures; 
use strict;
use warnings;
use 5.010;

func sum($a,$b) 
{ 
    return $a+$b; 
} 

say sum(100,20);
