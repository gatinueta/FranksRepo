use strict;
use warnings; 

sub test {
  my ($be24s) = @_;
  printf "0x%08lX  ", $_ for unpack_be24($be24s);
}

test ("\x01\x02\x03\x04\x05\x06\x07\x08\x09");
test ("\x00\xF0\x00\xF0\x00\x00\x00\x00\xF0");

sub unpack_be24 {
   my ($s) = @_;
   return map unpack('N', "\x00$_"), unpack '(a3)*', $s;
}

