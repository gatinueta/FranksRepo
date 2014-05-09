format Something =
Test: @<<<<<<<< @||||| @>>>>>
      $str,     $%,    '$' . int($num)
.

my $str = "widget";
my $cost = 120.15;
my $quantity = 10;
$num = $cost/$quantity;
$~ = 'Something';
write;

