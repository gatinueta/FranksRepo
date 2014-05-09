use File::Find;
use strict;

my @patterns = qw/
TABLE_NAME1
TABLE_NAME2
/;

# doesn't match TABLE_NAME11 or OTHER_TABLE_NAME1
#

sub wanted {
  if (-f) {
    open my $fh, '<', $_ or warn "can't open $_: $!\n", return;
    my $lineno = 0;
    while (my $line = <$fh>) {
      $lineno++;
      foreach my $pattern (@patterns) {
        if ($line =~ /\b$pattern\b/i) {
          chomp $line;
          print "$_: '$pattern' on line $lineno:$line\n";
        }
      }
    }
    close $_;
  }
}

find( \&wanted, '.');


