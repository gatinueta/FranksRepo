use Win32::API;
use strict;

#DWORD WINAPI GetCurrentDirectory(
#  __in   DWORD nBufferLength,
#  __out  LPTSTR lpBuffer
#);

my $getcurrentdir = new Win32::API(
    'kernel32', 'GetCurrentDirectory', 'NP', 'N',
);

my $length = $getcurrentdir->Call(0, undef);
print "require $length bytes\n";

my $f =  ' ' x ($length+1);

my $return = $getcurrentdir->Call($length, $f);
substr ($f, index ($f, chr(0))) = "";
print "$return, <$f>\n";

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

#my $opentiff = new Win32::API('C:/Users/admin/Downloads/tiff-3.8.2/libtiff/libtiff.dll', 'TIFFOpen', 'PP', 'P', '');
#
#print $opentiff, "\n";
#
#my $tiff = $opentiff->Call('example.tif', 'r');
#
#my $closetiff = new Win32::API('C:/Users/admin/Downloads/tiff-3.8.2/libtiff/libtiff.dll', 'TIFFClose', 'P', '', '');
#
#$closetiff->Call($tiff);

my $GetCommandLine = new Win32::API(
    'kernel32', 'GetCommandLine', '', 'P',
);

my $result = $GetCommandLine->Call();

print "command line is $result\n";

$GetCommandLine = new Win32::API(
    'kernel32', 'GetCommandLine', '', 'I',
);

my $result = $GetCommandLine->Call();

print "command line is ", deref_string($result), "\n";

##
#VOID WINAPI GetStartupInfo(
#  __out  LPSTARTUPINFO lpStartupInfo
#);
#
#typedef struct _STARTUPINFO {
#  4 DWORD  cb;
#  4 LPTSTR lpReserved;
#  4 LPTSTR lpDesktop;
#  4 LPTSTR lpTitle;
#  4 DWORD  dwX;
#  4 DWORD  dwY;
#  4 DWORD  dwXSize;
#  4 DWORD  dwYSize;
#  4 DWORD  dwXCountChars;
#  4 DWORD  dwYCountChars;
#  4 DWORD  dwFillAttribute;
#  4 DWORD  dwFlags;
#  2 WORD   wShowWindow;
#  2 WORD   cbReserved2;
#  4 LPBYTE lpReserved2;
#  4 HANDLE hStdInput;
#  4 HANDLE hStdOutput;
#  4 HANDLE hStdError;
#} STARTUPINFO, *LPSTARTUPINFO;

my $size = 17*4;

my $GetStartupInfo = new Win32::API(
    'kernel32', 'GetStartupInfo', 'I', '');

my $startupinfo_struct = "\x00" x $size;

$GetStartupInfo->Call(address_of($startupinfo_struct));

my @arr = unpack "LLLLLLLLLLLLSSLLLL", $startupinfo_struct; 
my @fields = qw(cb lpReserved lpDesktop lpTitle dwX dwY dwXSize dwYSize dwXCountChars dwYCountChars dwFillAttribute dwFlags wShowWindow cbReserved2 lpReserved2 hStdInput hStdOutput hStdError);

print "\nstartup info:\n";
foreach my $i (0..$#fields) {
  print "$fields[$i]: $arr[$i]\n";
  if ($fields[$i] eq "lpTitle" or $fields[$i] eq "lpDesktop") {
    print "  (", deref_string($arr[$i]), ")\n";
  }
}

print "\n";

#BOOL WINAPI ConvertStringSidToSid(
#  __in   LPCTSTR StringSid,
#  __out  PSID *Sid
#);

my $ConvertStringSidToSid = new Win32::API('advapi32', 'ConvertStringSidToSid', 'PI', 'I');

my $stringSID = "S-1-5-21-2226380161-1140953658-4289438231-1000";
# binary SID pointer as a scalar
my $binarySID_Psca = "\x00" x 8;
my $ret = $ConvertStringSidToSid->Call($stringSID, address_of($binarySID_Psca));
my $binarySID_P = unpack "L!", $binarySID_Psca;

my $IsValidSid = new Win32::API('advapi32', 'IsValidSid', 'I', 'I');

print "is valid sid: ", $IsValidSid->Call($binarySID_P), "\n";

print "binarySID as string is ", unpack ("H*", deref_string($binarySID_P) ), "\n";

#DWORD WINAPI GetLengthSid(
#  __in  PSID pSid
#);

my $GetLengthSid = new Win32::API('advapi32', 'GetLengthSid', 'I', 'I');

my $lengthSID = $GetLengthSid->Call($binarySID_P);

print "Length of SID is ", $lengthSID, "\n";

my $binarySID = deref($binarySID_P, $lengthSID);

print "binarySID is ", join (", ", unpack ("C$lengthSID", $binarySID)), "\n";
print "binarySID is 0x", unpack ("H*", $binarySID), "\n";

my ($account, $domain, $sidtype);
use Win32;
Win32::LookupAccountSID('', $binarySID, $account, $domain, $sidtype);

print "account is $domain\\$account ($sidtype)\n";

#HLOCAL WINAPI LocalFree(
#  __in  HLOCAL hMem
#);

my $LocalFree = new Win32::API('kernel32', 'LocalFree', 'I', 'I');

print "freed sid is ", $LocalFree->Call($binarySID), "\n";


