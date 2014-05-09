#!/usr/bin/perl -w
#use strict;
use DBI;

my $database = "test";
my $hostname = "localhost";
#my $port = 
my $dsn = "DBI:mysql:database=$database;host=$hostname"; #;port=$port";

my $user = "root";
my $password = "root";

my $dbh = DBI->connect($dsn, $user, $password);

my $sth = $dbh->prepare("SELECT * FROM franks_table");
$sth->execute();
while (my $ref = $sth->fetchrow_hashref()) {
	print "found a row: ";
	foreach my $tn (keys %{$ref}) {
	  my $val = $ref->{$tn};
	  print "$tn = ", ($val ? $val : "NULL"), " ";
  	}
	print "\n";
}


$sth->finish();

# Disconnect from the database.
$dbh->disconnect();




