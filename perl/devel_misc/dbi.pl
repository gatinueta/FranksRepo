#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use DBI;
use add_to_db;

my $dbfile = 'db.sqlite';
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","", 
	{ AutoCommit => 1, RaiseError => 1 });

add_to_db::create_db($dbh);
add_to_db::add_to_db($dbh);

$dbh->disconnect();

	

