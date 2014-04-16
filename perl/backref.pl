use strict; 
use warnings;
use 5.010;

$_ = shift;

my ($f) = /
        (?:            # non-capturing group
          (\d)           # a digit
          \1             # followed by itself
        ) +            # one or more times
/xp or die "no match";

say "matched $f (${^MATCH})"
