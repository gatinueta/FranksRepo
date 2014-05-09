#typedef struct _OSVERSIONINFOEX {
#  DWORD dwOSVersionInfoSize;
#  DWORD dwMajorVersion;
#  DWORD dwMinorVersion;
#  DWORD dwBuildNumber;
#  DWORD dwPlatformId;
#  TCHAR szCSDVersion[128];
#  WORD  wServicePackMajor;
#  WORD  wServicePackMinor;
#  WORD  wSuiteMask;
#  BYTE  wProductType;
#  BYTE  wReserved;
#} OSVERSIONINFOEX, *POSVERSIONINFOEX, *LPOSVERSIONINFOEX;

my $typeMap = {
  "DWORD" => { code => 'L', size => 4 },
  "TCHAR" => { code => 'Z', size => 1, array => 0 },
  "WORD" => { code => 'S', size => 2 },
  "BYTE" => { code => 'C', size => 1 },
}

my @osversionEx_struct = qw(L L L L L Z128 S S S C C);
my @osversionEx_name = qw(
dwOSVersionInfoSize
dwMajorVersion
dwMinorVersion
dwBuildNumber
dwPlatformId
szCSDVersion
wServicePackMajor
wServicePackMinor
wSuiteMask
wProductType
wReserved
);

my $osversionEx_size = 5*4+128+3*2 + 2*1;

my $osversioninfo = pack 'L', $osversionEx_size;

$osversioninfo .= 0 x ($osversionEx_size-length($osversioninfo));

use Win32::API; 
use Win32Util 'address_of'; 
my $GetVersionEx = new Win32::API( 'kernel32', 'GetVersionEx', 'I', 'I') or die qq($^E);

$GetVersionEx->Call(address_of($osversioninfo)) or die "GetVersionInfoEx: $^E";

my @arr = unpack join ("",  @osversionEx_struct), $osversioninfo;

foreach my $i (0..$#arr) {
  print $osversionEx_name[$i], ": ", $arr[$i], "\n";
}








