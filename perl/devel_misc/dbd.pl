use DBI;
use strict;

my $dbh = DBI->connect("dbi:SQLite:dbname=dbfile.db","","");

my $tables_sql = <<"EOF";
SELECT * FROM sqlite_master
WHERE type='table'
ORDER BY name;
EOF

my $tables_sth = $dbh->prepare($tables_sql);

$tables_sth->execute;
my $create = 1;
while(my $hr = $tables_sth->fetchrow_hashref()) {
  if (lc $hr->{name} eq "test_text") {
    $create = 0;
  }
  print "name: ", $hr->{name}, "\n";
}

if ($create) {
  $dbh->do("CREATE TABLE test_text (a text primary key, b text)");
}
#$dbh->do("create index pk on test_text (a)");

my $find_sth =
  $dbh->prepare("select b from test_text where a=?");
my $insert_sth = 
  $dbh->prepare("insert into test_text values (?, ?)");
my $update_sth =
  $dbh->prepare("update test_text set b=b+1 where a=?");
my $getall_sth =
  $dbh->prepare("select * from test_text order by a");
my $delete_sth =
  $dbh->prepare("delete from test_text where a=?");

foreach (1..100) {
  my $rn = int rand 21;
  
  if ($rn == 20) {
    my $victim = "hello " . int rand 20;
    print "deleting $victim\n";
    $delete_sth->execute($victim);
  } else {
    $find_sth->execute("hello $rn");
    my $row_ref = $find_sth->fetchrow_arrayref();
    if (defined $row_ref) {
      print "found $row_ref->[0] for key \"hello $rn\"\n";
      $update_sth->execute("hello $rn");
    } else {
      print "didn't find \"hello $rn\", inserting\n";
      $insert_sth->execute("hello $rn", 1);
    }
  }
}

$getall_sth->execute;
while (my $hr = $getall_sth->fetchrow_hashref()) {
  foreach (keys %$hr) {
    print "$_: $hr->{$_} ";
  }
  print "\n";
}

$dbh->disconnect;



