use strict;
use warnings;
use 5.010;

sub get_calc {
    my $v = shift;

    my $this = {};
    $this->{'mul'}  = sub { $v *= shift; $this; };
    $this->{'add'} = sub { $v += shift; $this; };
    $this->{'get'} = sub { $v };
  
    return $this;
}

my $calc = get_calc(100);
say $calc->{add}(100)->{mul}(3)->{get}();

