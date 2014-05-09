use Win32Util 'address_of';
use Win32::API;
use Win32::API::Callback;
use strict;

#HDC GetDC( 
#  HWND hWnd
#);
my $GetDC = new Win32::API('User32', 'GetDC', 'I', 'I') or die "GetDC: $^E";

#int EnumFontFamiliesEx(
#  __in  HDC hdc,
#  __in  LPLOGFONT lpLogfont,
#  __in  FONTENUMPROC lpEnumFontFamExProc,
#  __in  LPARAM lParam,
#  DWORD dwFlags
#);

#int CALLBACK EnumFontFamExProc(
#  const LOGFONT *lpelfe,
#  const TEXTMETRIC *lpntme,
#  DWORD FontType,
#  LPARAM lParam
#);

my $callback = Win32::API::Callback->new(
  sub { print "yeah: ", scalar @_, "\n"; return 1; },
  "IIII", "I",
) or die "Callback: $^E";

my $EnumFontFamiliesEx = new Win32::API('Gdi32', 'EnumFontFamiliesEx', 'IIKI', 'I') or die "EnumFontFamiliesEx: $^E";

my $hdc = $GetDC->Call(address_of(undef));

#typedef struct tagLOGFONT {
#  LONG  lfHeight;
#  LONG  lfWidth;
#  LONG  lfEscapement;
#  LONG  lfOrientation;
#  LONG  lfWeight;
#  BYTE  lfItalic;
#  BYTE  lfUnderline;
#  BYTE  lfStrikeOut;
#  BYTE  lfCharSet;
#  BYTE  lfOutPrecision;
#  BYTE  lfClipPrecision;
#  BYTE  lfQuality;
#  BYTE  lfPitchAndFamily;
#  TCHAR lfFaceName[LF_FACESIZE];
#} LOGFONT, *PLOGFONT;

# #define DEFAULT_CHARSET         1
# #define LF_FACESIZE         32
use constant DEFAULT_CHARSET => 1;
use constant LF_FACESIZE => 32;

my $logfont = pack 'IIIIICCCCCCCCa32', (0,0,0,0,0,0,0,0,DEFAULT_CHARSET,0,0,0,0,'');

$EnumFontFamiliesEx->Call( $hdc, address_of($logfont), $callback, 0 );




