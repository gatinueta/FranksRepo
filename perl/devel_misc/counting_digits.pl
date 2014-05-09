use integer;

sub f {
  my ($n, $d) = @_;
  my $c = 0;
  my $total = 0;
  for (my $k=0; $k<=$n; $k++) {
    my $i=$k;
    while ($i > 0) {
      my $dig = $i%10;
      $i /= 10;
      if ($dig == $d) { $c++; } 
      #print "$i\n";
    }
    $c++ if ($d==0);
    if ($k==$c) { 
      $total += $k;
      print "f($k,$d)==$c\n";
      print "total: $total\n";
    }
  }
  return $c;
}

print f(111199981, 1);


