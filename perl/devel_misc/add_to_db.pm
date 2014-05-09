package add_to_db;

use strict;
use warnings;
use 5.010;

use DBI;

sub create_db {
	my ($dbh) = @_;

	my $aref = $dbh->selectall_arrayref('select * from sqlite_master',
        	{ Slice => {} }
	);
	my $frauch_exists;
	foreach my $row (@$aref) {
        	if ($row->{'name'} eq 'frauch') {
                	$frauch_exists = 1;
        	}
	}

	if (!$frauch_exists) {
        	$dbh->do('create table frauch (a integer, s string)');
	}
}


sub add_to_db {
	my ($dbh) = @_;

	my ($maxa) = $dbh->selectrow_array('SELECT max(a) from frauch') // 0;
	say "max(a) is $maxa";
	$dbh->do(qq(insert into frauch (a, s) values ($maxa + 10, 'good')));
	$dbh->do(qq(insert into frauch (a, s) values ($maxa + 20, 'better')));

	my $sth = $dbh->prepare('select s, a from frauch order by a desc');
	while(my $aref = $sth->fetchrow_arrayref) {
		say "a is $aref->[1], s is $aref->[0]";
	}
}

1;

	

