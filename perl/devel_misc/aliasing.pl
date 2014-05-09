use strict;
our (@UNDER, $UNDER);

*UNDER = *_; 

sub func { 
    foreach (@UNDER) { 
        print $UNDER; 
    } 
} 

func(1..3);
print "\n";

*SLASH = *{/};
our $SLASH;

my $fh;

sub read_a_rec {
    seek $fh, 0, 0;
    print "\$/= ", ($/ // 'undef'), "\n";
    print scalar <$fh>;
}

{
    local $SLASH = undef;

    open $fh, '<', \"this is a line\nthis is another\nEOF\n";
    read_a_rec();
}

read_a_rec();

close $fh;

my $scalar = 'foo';
my @array  = 1 .. 5;

*foo = \$scalar;
*foo = \@array;

our ($foo, @foo);

print "Scalar foo is $foo\n";
print "Array foo is @foo\n";



