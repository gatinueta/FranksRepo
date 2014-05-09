#! /usr/bin/perl -w
use strict;
my @a = ( 'abc', 'def', 'ghi' );
@a = map { splice( @a, 0 ); $_ } ( @a );
print "done: @a\n";

