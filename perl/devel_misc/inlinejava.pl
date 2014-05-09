use strict;
use warnings;
use Inline (
    Java => 'STUDY', 
    'STUDY' => ['java.util.ArrayList', 'java.util.Random']
); 
my $l = new java::util::ArrayList(5); 
$l->add('gross');
$l->add('klein'); 

use Data::Dumper; 
print Dumper $l->toArray();

my $r = new java::util::Random(10293894);
print "random double: ", $r->nextDouble(), "\n";
my $arr = [1,2,3];

$r->nextBytes($arr);

print Dumper $arr
