use strict;
use warnings;
use 5.010;

my %index;

sub normalize {
	my $word = shift;
	return length $word;
}
	
while(my $line = <>) {
	my @words = split / /, $line;
	
	foreach my $word (@words) {
		my $nword = normalize($word);
		push @{ $index{$nword} }, $word;
	}
	
	use Data::Dumper;
	say Dumper \%index;
}

