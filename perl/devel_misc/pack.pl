sub address_of {
  my $p = pack "P", $_[0];
  return unpack "L!", $p;
}

sub deref_string {
  my $p = pack "L!", $_[0];
  return unpack "p", $p;
}

sub deref {
  my $p = pack "L!", $_[0];
  return unpack "P$_[1]", $p;
}

my $s = "hello world";
my $ptr = address_of ($s);

print "the ptr is $ptr\n";

$ptr++;
my $s2 = deref($ptr);
print "the value is $s2\n";
print "its length is ", length $s2, "\n";

vec($s2, 1, 8 ) = ord('L');

print "$s2, $s\n";

$s2 = unpack "p", $p;

substr($s2, 3, 2) = "M\x00";

print "$s2, $s\n";

$s2 = unpack "p", $p;

$s2 .= "X";

print "$s2, $s\n";








