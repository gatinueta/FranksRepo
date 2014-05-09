use Win32::API; 
my $v = new Win32::API('kernel32', 'GetComputerNameA', 'II', 'I') 
  or die qq($^E); 
use Win32Util 'address_of'; 

my $size = 121; 
my $p = 'X' x $size; 
my $sizeL = pack 'L!', $size; 
(my $res = $v->Call(address_of($p), address_of($sizeL))) or die "$^E"; 
$size = unpack 'L!', $sizeL; 
#print $size; 
print "<",substr($p, 0, $size),">";

