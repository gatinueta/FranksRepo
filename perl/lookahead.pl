use strict; 
use warnings;
use 5.010;

$_ = shift;

my ($f) = /
        (?:            # non-capturing group
          a            # the letter 'a'
          (
            (?=
              a *
            )
            (?=            # lookahead (followed by)
              \d           # a digit
              \1 ??        # followed by the lookahead capture
            )
          )                # catch the lookahead as a group
          \d *             # followed by any number of digits
        ) +           # one or more times
/xp or die "no match";

say "matched <$f> (${^MATCH})"
