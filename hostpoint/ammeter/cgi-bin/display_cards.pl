#!/usr/bin/perl -w
use DBI;
use CGI qw/:standard/;

use strict;

my $cgi = new CGI;
print $cgi->header;
print $cgi->start_html('Magic Cards');
	  
$SIG{__DIE__} = sub { print $cgi->pre(@_), "\n"; print $cgi->end_html; };
  
print p("enter a valid SQL WHERE clause below. (mysql)\n"), 
  $cgi->start_form ( -method => "GET" ),
  "query on MAGIC_CARDS: ",
  $cgi->textfield('q'),
  $cgi->p,
  $cgi->submit,
  $cgi->end_form;

my ($database, $hostname) = ("lagorda_magic", "lagorda.mysql.db.internal");
  
if ($cgi->param('h')) {
	$hostname = $cgi->param('h');
}

my ($user, $password) = ("lagorda_magic", "magic");

my $dsn = "DBI:mysql:database=$database;host=$hostname";

my $dbh = DBI->connect($dsn, $user, $password, {'RaiseError' => 1}) or die "can't connect: ", mysql_error(), "\n";

my $sql = "SELECT * FROM magic_cards";

if (my $q = $cgi->param('q')) {
	$sql .= " WHERE $q";
}
my $sth = $dbh->prepare( $sql ) or die "cannot prepare: $!\n";

$sth->execute() or die "cannot execute: $!\n";

my @names_arr = $sth->{'NAME'};

my @names = @{$names_arr[0]};

print "<!-- $sql -->\n";
  
print $cgi->start_table( { -border => 1 } );

print $cgi->Tr( join "", map { $cgi->th($_) } @names );
	
while (my @arr = $sth->fetchrow_array) {
		my $row = "";
		foreach(0 .. $#arr) {
			my $tentry;
			if ($names[$_] eq "card_name") {
				$tentry = $cgi->a(
					{href=> "http://ww2.wizards.com/gatherer/CardDetails.aspx?&name=" . $cgi->escape($arr[$_]) }, 
					$arr[$_] 
				);
			} else {
				$tentry = $arr[$_];
			}
			$tentry =~ s/\n/<BR>\n/;
			$row .= $cgi->td($tentry);
		}
		print $cgi->Tr( $row ), "\n";
}

print $cgi->end_table;
print $cgi->end_html;

$dbh->disconnect();

