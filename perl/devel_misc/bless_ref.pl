sub inc() { 
  ${$_[0]} += $_[1]; 
}  

sub say { 
  print "${$_[0]}\n"; 
} 

my $v;
my $o = bless \$v; 
$v = 100; 

$o->inc(2); 
$o->say();

print ref $o;

