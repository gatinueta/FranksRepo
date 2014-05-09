use charnames (); 
my $file = shift or die "Usage: $0 filename\n";

open FILE, "$file" or die "can't open $file: $!\n"; 
binmode FILE; 
my $buf; 
while ($buf = <FILE>) { 
  print join ", ", 
    map { charnames::viacode(ord) } 
      split //, $buf;
    print "\n";
}



