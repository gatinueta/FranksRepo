use strict;
use feature qw(say);

my $r1 = qr/(abc)*+ab/; 
my $r2 = qr/(abc)*ab/; 

my $str1 = "abcabcab"; 
my $str2 = "abcabcabc";

foreach my $str ($str1, $str2) {
  foreach my $r ($r1, $r2) {
    if ($str =~ $r) {
      say "$r matches $str: $&";
    } else {
      say "$r doesn't match $str";
    }
  }
}


