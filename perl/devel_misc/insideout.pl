package Hidden;
use Scalar::Util 'refaddr';
{
    my %name;
    my %admirers;

    sub new {
        my ($package, $par_name ) = @_;
        my $scalar;
        my $obj = bless \$scalar, $package;
        $name{ refaddr $obj } = $par_name;

        return $obj;
    }

    sub get_name {
        my $obj = shift;
        return $name{ refaddr $obj };
    }

    sub set_name {
        my ($obj, $par_name) = @_;

        $name{ refaddr $obj } = $par_name;
    }

    sub get_admirers {
        my $obj = shift;
        my $admirers_ref = $admirers{ refaddr $obj };
        return $admirers_ref ? @$admirers_ref : ();
    }

    sub add_admirer {
        my ($obj, $admirer) = @_;
        my $admirers_ref = $admirers{ refaddr $obj };
        if ($admirers_ref) {
            push @$admirers_ref, $admirer;
        } else {
            $admirers{ refaddr $obj } = [ $admirer ];
        }
    }

    sub DESTROY {
        my $obj = shift;
        if (exists($name{ refaddr $obj })) {
            print "removing $name{ refaddr $obj }...\n";
            delete $name{ refaddr $obj };
            delete $admirers{ refaddr $obj };
        }
    }
}

package main;
use strict;
{
    my $hidden_hidden = new Hidden('gone out');
}

my $hidden = Hidden->new('Herrgott');
my $hidden2 = Hidden->new('Tonner');

#$Hidden::name{ refaddr $hidden } = 'xorxix';

print $hidden->get_name(), "\n";
print $hidden2->get_name(), "\n";

$hidden->add_admirer('god');
$hidden->add_admirer('devil');

print join (', ', $hidden->get_admirers()), "\n";

undef $hidden;



