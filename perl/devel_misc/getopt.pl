use Getopt::Long;
use strict;

my $long = 0;
my $length = 100;
my $verbose = 0;
my $height = 0;
my @libs = ();

GetOptions(
  'long' => \$long, 
  'length=n' => \$length, 
  'verbose+' => \$verbose,
  'height=f' => \$height,
  'lib=s' => \@libs);

print "long: $long\n";
print "Length: $length\n";
print "verbose: $verbose\n";
print "height: $height\n";
print "libs: ", join (',', @libs), "\n";

foreach my $arg (@ARGV) {
  print "$arg ";
}

