use Win32::API;
use strict;

use constant TWLG_GERMAN_SWISS => 62;
use constant TWCY_SWITZERLAND => 41;
use constant TWON_PROTOCOLMAJOR => 2;
use constant TWON_PROTOCOLMINOR => 1;
use constant DG_IMAGE => 0x0002;
use constant DG_CONTROL =>  0x0001;
use constant DAT_PARENT => 0x0004;
use constant MSG_OPENDSM => 0x0301;

use Tkx;
my $mw = Tkx::widget->new(".");
my $whandle = hex Tkx::winfo('id', $mw);

print "the handle is $whandle\n";

#HMODULE hInstance = GetModuleHandle(NULL);
my $GetModuleHandle = Win32::API->new(
    'kernel32', 'HMODULE GetModuleHandle( LPCTSTR lpModuleName )'
) or die "cannot import: $!";

#my $hInstance = $GetModuleHandle->Call(undef);
#print "hInstance is $hInstance\n";


#typedef struct {
#   TW_UINT16  MajorNum;  /* Major revision number of the software. */
#   TW_UINT16  MinorNum;  /* Incremental revision number of the software. */
#   TW_UINT16  Language;  /* e.g. TWLG_SWISSFRENCH */
#   TW_UINT16  Country;   /* e.g. TWCY_SWITZERLAND */
#   TW_STR32   Info;      /* e.g. "1.0b3 Beta release" */
#} TW_VERSION, FAR * pTW_VERSION;

#### define the structure
Win32::API::Struct->typedef( TW_VERSION => qw{
    USHORT MajorNum;
    USHORT MinorNum;
    USHORT Language;
    USHORT Country;
    CHAR Info[34];
});


#/* DAT_IDENTITY. Identifies the program/library/code resource. */
#typedef struct {
#   TW_UINT32  Id;              /* Unique number.  In Windows, application hWnd      */
#   TW_VERSION Version;         /* Identifies the piece of code              */
#   TW_UINT16  ProtocolMajor;   /* Application and DS must set to TWON_PROTOCOLMAJOR */
#   TW_UINT16  ProtocolMinor;   /* Application and DS must set to TWON_PROTOCOLMINOR */
#   TW_UINT32  SupportedGroups; /* Bit field OR combination of DG_ constants */
#   TW_STR32   Manufacturer;    /* Manufacturer name, e.g. "Hewlett-Packard" */
#   TW_STR32   ProductFamily;   /* Product family name, e.g. "ScanJet"       */
#   TW_STR32   ProductName;     /* Product name, e.g. "ScanJet Plus"         */
#} TW_IDENTITY, FAR * pTW_IDENTITY;

#### define the structure
Win32::API::Struct->typedef( TW_IDENTITY => qw{
    LONG Id;
    TW_VERSION Version;
    USHORT ProtocolMajor;
    USHORT ProtocolMinor;
    ULONG SupportedGroups;
    CHAR Manufacturer[34];
    CHAR ProductFamily[34];
    CHAR ProductName[34];
});

#{0,{5,9,TWLG_GERMAN_SWISS,TWCY_SWITZERLAND,"0"},TWON_PROTOCOLMAJOR,TWON_PROTOCOLMINOR,DG_IMAGE | DG_CONTROL,"BSI AG","DUPLEX","SCANPROC"};
my $version = Win32::API::Struct->new('TW_VERSION');
print "TW_VERSION is ",$version->sizeof, " bytes long\n";

$version->{MajorNum} = 5;
$version->{MinorNum} = 9;
$version->{Language} = TWLG_GERMAN_SWISS;
$version->{Country} = TWCY_SWITZERLAND;
$version->{Info} = '0';

my $TwainId = Win32::API::Struct->new('TW_IDENTITY');
$TwainId->{Id} = 0;
$TwainId->{Version} = $version;
$TwainId->{ProtocolMajor} = TWON_PROTOCOLMAJOR;
$TwainId->{ProtocolMinor} = TWON_PROTOCOLMINOR;
$TwainId->{SupportedGroups} = DG_IMAGE|DG_CONTROL;
$TwainId->{Manufacturer} = 'Frankie';
$TwainId->{ProductFamily} = 'FrankSoft';
$TwainId->{ProductName} = 'PerlTwainBridge';

my $DSM_Entry = Win32::API->new(
    'twain_32', 'SHORT DSM_Entry( LPTW_IDENTITY pOrigin,
                                  LPTW_IDENTITY pDest,
                                  LONG    DG,
                                  USHORT    DAT,
                                  USHORT    MSG,
                                  LPVOID    pData)') or die "cannot import: $!";

my $DestId = Win32::API::Struct->new('TW_IDENTITY');
print "now calling DSM_Entry....\n";
my $ret = $DSM_Entry->Call($TwainId, $DestId, DG_CONTROL, DAT_PARENT, MSG_OPENDSM, pack ('L', $whandle));

