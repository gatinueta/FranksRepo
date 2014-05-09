package Win32Util;

require Exporter;

@ISA = ('Exporter');

@EXPORT_OK = qw(address_of deref_string deref);

sub address_of {
  my $p = pack "P", $_[0];
  return unpack "L!", $p;
}

sub deref_string {
  my $p = pack "L!", $_[0];
  return unpack "p", $p;
}

sub deref {
  my $p = pack "L!", $_[0];
  return unpack "P$_[1]", $p;
}

1;

