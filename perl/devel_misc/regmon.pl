use Win32::Registry;
use strict;
my $win_key;
$::HKEY_CURRENT_USER->Open(
  "Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows", $win_key) or 
  die "Can't open windows reg key: $^E";
my ($type, $value);
$win_key->QueryValueEx("Device", $type, $value) or die "No Device: $^E";
print "Here's your default printer: $value\n";

use Win32::API;

#LONG WINAPI RegNotifyChangeKeyValue(
#  __in      HKEY hKey,
#  __in      BOOL bWatchSubtree,
#  __in      DWORD dwNotifyFilter,
#  __in_opt  HANDLE hEvent,
#  __in      BOOL fAsynchronous
#);

use Win32::API;

my $RegNotifyChangeKeyValue = new Win32::API('advapi32', 'RegNotifyChangeKeyValue', 'IIIII', 'I');

my $null = pack 'P', undef;
my $res = $RegNotifyChangeKeyValue->Call($win_key->{'handle'}, 0, 0x00000004, $null, 0);

print "returned $res\n";


