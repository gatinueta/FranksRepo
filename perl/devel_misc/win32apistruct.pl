use Win32::API; 
use strict;
my $f = Win32::API->new('win32apistruct', 'int f(int i)') or die $!; 
print 'f(3)==',$f->Call(3), "\n";
my $f2 = Win32::API->new('win32apistruct', 'int f2(int x1, int x2, BOOL add)') or die $!;
my $res = $f2->Call(-10, 8, 0);
print "f2(-10,8,0)==$res\n";

Win32::API::Struct->typedef( 'MyStruct', qw(
    SHORT x1;
    SHORT x2;
    char s[20];
 ));


my $mod_struct = Win32::API->new('win32apistruct', 'VOID mod_struct(LPMyStruct mystruct)') or die $!;

my $mystruct = Win32::API::Struct->new('MyStruct');

$mystruct->{x1} = 100;
$mystruct->{x2} = -3;
$mystruct->{s} = 'the string';

$mod_struct->Call($mystruct);
$mod_struct->Call($mystruct);

print "x1=$mystruct->{x1}\n";
print "x2=$mystruct->{x2}\n";
print "s=$mystruct->{s}\n";


# passing an int*: the easy way. But can't pass a NULL pointer

Win32::API::Struct->typedef( 'IntStruct', qw(
 INT i;
));

my $mod_int = Win32::API->new('win32apistruct', 'BOOL mod_int(LPIntStruct ip)') or die $!;

print "mod_int(NULL) replied ", $mod_int->Call(undef), "\n";


my $intstr = new Win32::API::Struct->new('IntStruct');
$intstr->{i} = 20;
print "mod_int(&20) replied ", $mod_int->Call($intstr), "\n";
print "mod_int(NULL) replied ", $mod_int->Call(undef), "\n";
print "i is now $intstr->{i}\n";

# passing an int* the hard way. But it's easy to pass a NULL pointer using undef
my $mod_int2 = Win32::API->new('win32apistruct', 'BOOL mod_int(INT lpInt)') or die $!;

use Win32Util 'address_of';


my $i = pack 'l', -20;

print "mod_int2(-20) replied ", $mod_int2->Call(address_of($i)), "\n";
print "mod_int2(NULL) replied ", $mod_int2->Call(undef), "\n";

print "i is now ", unpack ('l', $i), "\n";


# how do void* work?
my $print_void = Win32::API->new('win32apistruct', 'VOID print_void(LPVOID vp, INT kind)') or die $!;

my $s = 'igrec';
printf "the address is 0x%x\n", address_of($s);

$print_void->Call($s, 0);

$print_void->Call(pack ('L', 0xdeadbeef), 1);



