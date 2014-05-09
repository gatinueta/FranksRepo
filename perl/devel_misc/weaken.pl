package MyString;
use overload q("") => \&tostring;

sub new {
    my ($package, $string) = @_;
    return bless [ $string ], $package;
}

sub tostring {
    my ($self) = @_;
    return "$self->[0] (MyString)";
}

sub DESTROY {
    print "MyString object '$_[0]->[0]' destroyed\n";
}

package main;
use strict;
use Scalar::Util 'weaken';
use Data::Dumper;

my $globref;

sub getref {
    my $s = new MyString('hello');
    $globref = \$s;
    return \$s;
}

my $cref = getref();

# two strong references to string
print Dumper $cref;
weaken $cref;
# one strong reference remaining ($globref)
print Dumper $cref;
{
    my $copycref = $cref;
    # copying makes a strong ref: now back to 2 strong references
    undef $globref;
    # now only one left
    print Dumper $cref;
}

# $copyref out of scope: no more strong references => $cref is undef
print Dumper $cref;

my $mystr = new MyString('a string');

print $mystr, "\n";

