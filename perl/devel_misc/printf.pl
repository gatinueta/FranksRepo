use Win32::API;

my $printf = new Win32::API('MSVCR71', 'printf', 'PIP', 'I', '_cdecl') 
  or die "$^E";

$printf->Call("hello %d %s world", 1, "cruel");


