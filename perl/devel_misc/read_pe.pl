use Fcntl qw(SEEK_SET);
use strict;
use feature 'switch';

sub readstruct {
  my ($fh, $size_ref, $name_ref) = @_;
  
  my $template = '';
  my $size = 0;
  foreach my $i (0 .. $#$size_ref) {
    given (${$size_ref}[$i]) {
      when (2) { $size += 2; $template .= 'S'; }
      when (4) { $size += 4; $template .= 'L'; }
    }
  }

  my $struct;
  read $fh, $struct, $size;

  my @arr = unpack $template, $struct;

  foreach my $i (0..$#arr) {
    print ${$name_ref}[$i], ": ", $arr[$i], "\n";
  }
}

my $file = shift;

open my $fh, '<', $file or die "can't open $file: $!\n";

binmode $fh;

my $msdos_header;

read $fh, $msdos_header, 0x3c; 

read $fh, my $offset_str, 4;

my $offset = unpack 'L!', $offset_str;

print "PE signature offset is $offset\n";

seek $fh, $offset, SEEK_SET;

read $fh, my $signature, 4;

if ($signature eq "PE\0\0") {
  print "is a PE file\n";
}

my @coff_header_size = qw(2 2 4 4 4 2 2);
my @coff_header_name = qw(Machine NumberOfSections TimeDateStamp PointerToSymbolTable NumberOfSymbols SizeOfOptionalHeader Characteristics);

readstruct( $fh, \@coff_header_size, \@coff_header_name);

close $fh;

