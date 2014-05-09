#!/usr/bin/perl -w

sub rotten {
	my %codes = ();
	my @symbols = ('a'..'z', 'A'..'Z', '0'..'9', '.', ',', ':' );
	foreach (@symbols) {
		$codes{$_} = $_;
	}

	while (@symbols > 1) {
		my ($v1) = splice @symbols, 13%@symbols, 1;
		my ($v2) = splice @symbols, 23%@symbols, 1;

		my $tmp = $codes{$v1};
		
		$codes{$v1} = $codes{$v2};
		$codes{$v2} = $tmp;
	}

	my %rcodes = reverse %codes;
	my $res;

	if ($_[0] =~ /^h/) {
		$res = "r";
		foreach (split //, $_[0]) {
			$res .= $codes{$_};
		}
		return $res;
	} else {
		$res = "";

		foreach(split //, $_[0]) {
			$res .= $rcodes{$_};
		}
		return substr $res, 1;
	}
}

print rotten ("hillbilli"), "\n";

print rotten ("r1f77Tf77f"), "\n";

