use XML::Parser;
use GD;
use feature qw(switch);

use strict;

my @layouts = ();
my $current_layout = {};

sub handle_start {
  my $expat = shift;
  my $element = shift;

  given ($element) {
    when ("names") {
      $current_layout->{names} = [];
    }
    when ("golist") {
      $current_layout->{golist} = [];
    }
  }
  given ($expat->current_element()) {
    when ("golist") {
      push @{$current_layout->{golist}}, { type => $element };
    }
  }

  while (@_) {
    print shift, "= ", shift, "\n";
  }
}

sub handle_char {
  my ($expat, $str) = @_;

  if ($expat->within_element("layout")) {
    given ($expat->current_element()) {
      when ("name") { 
        if ($expat->within_element("names")) {
          push @{$current_layout->{names}}, $str; 
        }
      }
      when ("x") {
        if ($expat->within_element("golist")) {
          ${$current_layout->{golist}}[-1]->{x} = $str;
        }
      }
    }
  } 
}

sub handle_end {
  my $expat = shift;
  my $element = shift;

  given($element) {
    when ("layout") {
      push @layouts, $current_layout;
      $current_layout = {};
    }
  }
}

#my $parser = new XML::Parser(Handlers => {Start => \&handle_start,
#             End   => \&handle_end,
#             Char  => \&handle_char});
#
#
#$parser->parsefile("c:/Users/admin/devel/BSI/trunk/cpp/CLBD/LabelLayouts.xml");
#
use Data::Dumper;
#print Dumper @layouts;

#my $parser2 = new XML::Parser(Style => "Tree");

#my $tree = $parser2->parsefile("c:/Users/admin/devel/BSI/trunk/cpp/CLBD/LabelLayouts.xml");

use XML::Simple;

my $ref = XMLin("c:/Users/admin/devel/BSI/trunk/cpp/CLBD/LabelLayouts.xml", ForceArray => 1);

print $ref;

sub printout($$) {
  my ($attr,$val) = @_;

  if (ref $val eq "HASH") {
    print "$attr...:\n";
    foreach my $sub (keys %$val) {
      my $subval = $val->{$sub};
      printout($sub, $subval); 
    }
    print "...$attr\n";
  } elsif (ref $val eq "ARRAY")  {
      my $ser = join (", ", @$val);
      print "${attr}s: $ser\n";
  } else  {
    print "$attr: $val\n";
  }
}


foreach my $layout (@{$ref->{layouts}->[0]->{layout}}) {
  printout ("layout", $layout);
}



