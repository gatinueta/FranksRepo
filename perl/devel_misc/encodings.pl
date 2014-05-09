use strict;
use warnings;
use feature 'say';

use Encode; 
use charnames ':full';

system 'chcp 65001';

binmode STDOUT, ':encoding(utf-8)';

my $hebrew_alef = chr(0x05d0); 
my $string = 'Äléƒ ' . $hebrew_alef . "\N{GREEK SMALL LETTER SIGMA}¼";
$string = shift if (@ARGV);
my $latin_encoded = encode ( 'iso-latin-1', $string); 
say 'characters                   ',
    map { sprintf '     %s ',  $_  } split //, $string;
say 'unicode code points:         ', 
    map { sprintf 'U+%04x ',   ord } split //, $string; 
say 'iso-latin-1 character codes: ', 
    map { sprintf '    %02x ', ord } split //, $latin_encoded;
my @encoded_utf8 = map { encode_utf8 $_ } split //, $string;

my @utf8_chars;
foreach my $useq (@encoded_utf8) {
    push @utf8_chars, join '', map { sprintf '%02x', ord } split //, $useq;
}
say 'utf8 encoded string:         ', 
    map { sprintf '%6s ', $_ } @utf8_chars;

say 'charnames:                   ',
    join ', ', map { charnames::viacode(ord $_) } split //, $string;



