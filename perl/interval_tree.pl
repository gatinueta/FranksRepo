use strict;
use warnings;
use 5.010;

use Set::IntervalTree;
my $tree = Set::IntervalTree->new;
$tree->insert("ID1",100,200);
$tree->insert(2,50,100);
$tree->insert({id=>3},520,700);
$tree->insert('late',1000,1100);

my $results = $tree->fetch(400,800);
print scalar(@$results)." intervals found.\n";
use Data::Dumper;
say Dumper $results;

