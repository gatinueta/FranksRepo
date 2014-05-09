my @chars = (0x21 .. 0x7e, 0x2200 .. 0x22f0);

binmode STDOUT, ':utf8';


while(1) {
  if (rand(10)<1) {
    print "\n";
  } 
  my $r = int rand(scalar @chars);
  print chr($chars[$r]);
}


