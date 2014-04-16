use strict;
use warnings;
use 5.010;

sub TIESCALAR {
  bless {}, 'main';
}

sub FETCH {
  say 'FETCH';
  shift;
}

use overload
  '+' => sub { say 'add called'; },
  '0+' => sub { say 'tonum called'; },
  '""' => sub { say 'tostr called'; };

tie my $a, 'main';

say "adding tied     (call $_): ", $a+1 for (1..2);

