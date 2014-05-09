use strict;
use warnings;
use Inline Java => <<'END_OF_JAVA_CODE' ;
   class Identify {
        public Identify() {}
        public int getLength(Object[] arr) {
            return arr.length;
        }

        public byte[] fill(byte[] arr, byte value) {
            System.out.println("the length is " + arr.length);
            for (int i=0; i<arr.length; i++) {
                arr[i] = value;
            }
            return arr;
        }
    }
END_OF_JAVA_CODE

my $i = new Identify();
my $barr = [1,2,3];

my $barr2 = $i->fill($barr, 6);

use Data::Dumper;

print Dumper($barr, $barr2);

$i->fill($barr2, 5);

print Dumper($barr, $barr2);




