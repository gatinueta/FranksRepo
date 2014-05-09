use Net::FTP;

my $filename = shift;

$ftp = Net::FTP->new("ftp.ammeter.ch", Debug => 0)
  or die "Cannot connect to ftp.ammeter.ch: $@";

$ftp->login("lagorda",'los39xs')
  or die "Cannot login ", $ftp->message;

$ftp->cwd("/public_html/ammeter/cgi-bin")
  or die "Cannot change working directory ", $ftp->message;

$ftp->put( $filename ) or warn "Couldn't upload $filename: ", $ftp->message;

$ftp->site("CHMOD 755 $filename") or warn "Couldn't chmod $filename ", $ftp->message;

foreach my $line ($ftp->dir( $filename )) {
  print "$line\n";
}

$ftp->close();


