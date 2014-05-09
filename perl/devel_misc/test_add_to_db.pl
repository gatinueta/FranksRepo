#!/usr/bin/perl
use strict;
use warnings;

use add_to_db;

use Test::More tests => 5;

use DBI;
use add_to_db;

my $dbh;
my $dbfile = 'dbtest.sqlite';

sub count {
	my ($count) = $dbh->selectrow_array('select count(*) from frauch');
	
	return $count;
}

sub test_add {
	my ($count_so_far) = @_;
	$dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","",
        	{ AutoCommit => 1, RaiseError => 1 });

	add_to_db::create_db($dbh);
	add_to_db::add_to_db($dbh);

	is(count(), $count_so_far+2, 'creates 2 records');
	add_to_db::add_to_db($dbh);
	ok(count() == $count_so_far+4, 'creates 2x2 records');

	$dbh->disconnect();
}

unlink $dbfile;
test_add(0);
test_add(4);
ok(1==1, 'identity');
