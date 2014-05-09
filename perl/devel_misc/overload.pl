package IO::Handle;
use overload q("") => sub { return 'an IO handle' };

package main;

print ref (\*STDOUT), "\n";

open my $fh, '<', 'overload.pl';

print $fh;

