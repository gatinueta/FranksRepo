use Win32::API;
use strict;

sub address_of {
  my $p = pack "P", $_[0];
  return unpack "L!", $p;
}

#char *strncpy(
#   char *strDest,
#   const char *strSource,
#   size_t count 
#);

my $strncpy = new Win32::API('MSVCR71', 'strncpy', 'III', 'P', '_cdecl') or die "strncpy: $!";

my $string = "good friday, dear\x00isn't it\x00";

my $dest_string = "X" x (2+length($string));

my $res_string = $strncpy->Call(
  address_of($dest_string), 
  address_of($string), 
  length($string)
);

print "dest string is ", unpack ("H*", $dest_string), "\n";
print "dest string is  ", join (" ", split //, $dest_string), "\n";

print "return value was <$res_string>\n";

#errno_t strcat_s(
#   char *strDestination,
#   size_t numberOfElements,
#   const char *strSource 
#);
my $strcat_s = new Win32::API('msvcr100_clr0400.dll', 'strcat_s', 'III', 'I', '_cdecl') or die "strcat_s: $!";

#$strcat_s->Call(address_of($dest_string), 2, address_of($string));

#print "dest string is ", unpack ("H*", $dest_string), "\n";
#print "dest string is  ", join (" ", split //, $dest_string), "\n";





