use Win32::API;
use Win32Util 'address_of';
use strict;

#typedef struct _system_info {
#  union {
#    dword  dwoemid;
#    struct {
#      word wprocessorarchitecture;
#      word wreserved;
#    };
#  };
#  DWORD     dwPageSize;
#  LPVOID    lpMinimumApplicationAddress;
#  LPVOID    lpMaximumApplicationAddress;
#  DWORD_PTR dwActiveProcessorMask;
#  DWORD     dwNumberOfProcessors;
#  DWORD     dwProcessorType;
#  DWORD     dwAllocationGranularity;
#  WORD      wProcessorLevel;
#  WORD      wProcessorRevision;
#} SYSTEM_INFO;

my @struct_type = qw(L L L! L! L! L L L S S);
my @struct_descr = qw(dwoemid dwPageSize lpMinimumApplicationAddress lpMaximumApplicationAddress dwActiveProcessorMask dwNumberOfProcessors dwProcessorType dwAllocationGranularity wProcessorLevel wProcessorRevision);

my $GetSystemInfo = new Win32::API('kernel32', 'GetSystemInfo', 'I', '' )
  or die "$^E";

my $systeminfo = "\x0" x 1000;
$GetSystemInfo->Call(address_of($systeminfo));

my @arr = unpack join ("", @struct_type), $systeminfo;
foreach my $i (0 .. $#struct_descr) {
  print "$struct_descr[$i]: $arr[$i]\n";
}

