use strict;
use warnings;

sub readChunkHeader {
  my $buf;
  my $fh = shift;
  read $fh, $buf, 8 or return undef;
  my @arr = unpack "A4L", $buf;

  my $fmtLength = $arr[1];

  my $i=0;
  foreach (qw/chunkType fmtLength/) {
    print "$_:", $arr[$i++], "\n";
  }

  return @arr;
}

foreach my $filename (@ARGV) {
  open my $file, "<$filename" or die "can't open $filename: $!\n";
  binmode $file;
  read $file, my $buf, 12 or die "unexpected EOF: $!\n";
  my @arr = unpack "A4LA4", $buf;

  foreach (qw/chunkId ChunkSize riffType/) {
    print "$_:", shift @arr, "\n";
  }
  
  readChunkHeader($file);

  read $file, $buf, 16;
  @arr = unpack "SSLLSS", $buf;

  my $blockAlign = $arr[4];
  my $nofChannels = $arr[1];
  my $bitsPerSample = $arr[5];

  foreach (qw/formatTag channels sampleRate bytesPerSecond blockAlign bitsPerSample/) {
    print "$_:", shift @arr, "\n";
  }

  my ($chunkType, $fmtLength) = readChunkHeader($file);

  for (my $sample=0; $sample<$fmtLength/$blockAlign; $sample++) {
    read $file, $buf, $blockAlign;

    my $offset = 0;
    foreach my $channel (0..$nofChannels-1) {
      if ($bitsPerSample==16) {
        my $val = unpack "s", substr($buf, $offset);
        $offset+=2;
        printf "channel %d, sample %05d: %+04d\n", $channel, $sample, $val;
      }
    }
  }

  @arr = readChunkHeader($file);

  if ($arr[0]) {
    print "continued: @arr...\n";
  }

  close $file;
}

