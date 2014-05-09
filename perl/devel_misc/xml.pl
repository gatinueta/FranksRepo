use XML::Parser;

sub main {
  $p1 = new XML::Parser(Style => 'Debug');
#$p1->parsefile('REC-xml-19980210.xml');
  $p1->parse('<foo id="me">Hello World</foo>');
}

main;

sub drillo {
  my $drill = 1/7;

  return $drill . "o";
}

print drillo(20);

