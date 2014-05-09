package F;

sub new {
    return bless {};
}

sub incr {
    my $self = shift;
    return ++$self->{count};
}

sub dump {
    use Data::Dumper;
    print Dumper(shift);
}

package G;

sub new {
    my ($package, $delegate) = @_;
    return bless { delegate => $delegate }, $package;
}

sub AUTOLOAD {
    # DESTROY messages should never be propagated.
    return if $AUTOLOAD =~ /::DESTROY$/;
    
    my $func = $AUTOLOAD;
    $func =~ s/.*:://;
    print "calling $func...\n";
    my $self = $_[0];
    $self->{delegate}->$func(@_);
}

package main;

my $g = new G(new F());

foreach (1..3) {
    $g->incr();
}

$g->dump();

package main;
use Math::Complex;
$g = new G(Math::Complex->make(5, 6));

#print "$g";
print '$g == ', Re($g), '+i*', Im($g), "\n";



    
