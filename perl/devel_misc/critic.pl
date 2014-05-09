use Perl::Critic;
use strict;

my $file = shift;
my $critic = Perl::Critic->new();
my @violations = $critic->critique($file);
print @violations;

