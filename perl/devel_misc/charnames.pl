use charnames ':full'; 
use feature 'say';

binmode STDOUT, ':utf8'; 
foreach (0 .. 10000) { 
  my $name = charnames::viacode($_);
  if ($name) {
    printf "<  %s  > (0x%06x): \"%s\"\n", chr($_), $_, $name;
  }
}

