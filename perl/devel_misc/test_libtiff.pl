use Win32::API;
use strict;

#$Win32::API::DEBUG = 1;
my $pattern = shift or die "perl $0 <filename_pattern>\n";

$pattern =~ s|\\|/|g;

print "globbing $pattern....\n";
my @files = glob($pattern);

my $dll = "libtiff3";

my $functionTiffOpen = new Win32::API( $dll, 'TIFFOpen', 'PP', 'I', '_cdecl');

my $functionTiffClose = new Win32::API( $dll, 'TIFFClose', 'I', '', '_cdecl');

use constant TIFFTAG_BITSPERSAMPLE => 258;
use constant TIFFTAG_IMAGEWIDTH => 256;

my $functionTiffGetField = new Win32::API( $dll, 'TIFFGetField', 'IIP', 'I', '_cdecl');


foreach my $filename (@files) {

  print "TIFFOpen(\"$filename\")...\n";
  my $tiff_p = $functionTiffOpen->Call($filename, "r");
  printf "TIFFOpen returned $tiff_p (0x%x)\n", $tiff_p;  

if ($tiff_p) {  
	#  struct tiff {
	#		char*		tif_name;	/* name of open file */
	#		int		tif_fd;		/* open file descriptor */
	#		int		tif_mode;	/* open mode (O_*) */
	#		uint32		tif_flags;
	#		toff_t		tif_diroff;	/* file offset of current directory */
	#		...
	#  }

	# pack the pointer into a scalar	
	my $memptr = pack 'L!', $tiff_p;
	
	# read 40 bytes (8x5) from it
  my $tiff_struct = unpack "P40", $memptr;
  
  # decode 5 longs
  my ($tif_name, $tif_fd, $tif_mode, $tif_flags, $tif_diroff) = unpack("L5", $tiff_struct);
  
  printf "tif_name=0x%x, tif_fd=$tif_fd, tif_mode=$tif_mode, tif_flags=$tif_flags, tif_diroff=$tif_diroff\n", $tif_name;
  

  # make room for an uint16
  my $bitsPerSample = 0 x 2;
  $functionTiffGetField->Call($tiff_p, TIFFTAG_BITSPERSAMPLE, $bitsPerSample);
  print "bits per sample: ", unpack ('S', $bitsPerSample), "\n";

  my $imageWidth = 0 x 4; # uint32	
  $functionTiffGetField->Call($tiff_p, TIFFTAG_IMAGEWIDTH, $imageWidth);
  print "image width: ", unpack ('L', $imageWidth), "\n";
		
    print "calling TIFFClose\n";
    $functionTiffClose->Call($tiff_p);
    print "TIFFClose finished\n";
  }
  
}


#my $value = $functionTiffOpen->Call($lpt, $len);
