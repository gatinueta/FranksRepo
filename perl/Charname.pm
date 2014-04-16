package Charname;

use strict;
use warnings;
use 5.010;
use charnames ();
use base qw(Exporter);

our @EXPORT_OK = qw(explain);

sub explain {
    while (my $str = shift) {
        foreach my $code (unpack "W*", $str) {
            my $c = chr($code);
            my $bytes = $c; 
            utf8::encode($bytes);
            printf "%s: U+%04x (%s), encoded: %s\n", 
                $c, 
                $code, 
                charnames::viacode($code), 
                join ', ', map { sprintf '%02x', $_ } unpack 'C*', $bytes;
        }
        say '';
    }
}

1;

