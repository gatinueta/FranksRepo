use Win32::API;

my $GetModuleHandle = new Win32::API( 'kernel32', 'GetModuleHandle', 'P', 'I') or die qq($^E);

my $hModule = $GetModuleHandle->Call( 'kernel32' );

my $GetProcAddress = new Win32::API( 'kernel32', 'GetProcAddress', 'I
print "$hModule\n";

