use strict;
use warnings;
use 5.010;

{
    my $id = 'A';
    my $id2 = 1;
    sub get_next {
        show();
        return $id++;
    }

    sub show {
        use PadWalker qw(peek_my peek_sub);
        use Data::Dumper;
        say Dumper(peek_my(0));
    }
    sub get_id2_getter {
#        return sub { return $id2++; }
    }
}

say get_next(), get_next();
#get_id2_getter()->();
show();
say get_next();
show();


