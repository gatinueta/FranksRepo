use strict;

use Data::Dumper;

my $curturn = 0;

use constant MAXTURNS => 50;

sub game {
  my $larry_cache = {
    "name" => "larry",
    "strategy" => "lru",
    "cache" => [],
    "score" => 0,
  };

   my $robin_cache = {
    "name" => "robin",
    "strategy" => "lifo",
    "cache" => [],
    "score" => 0,
  };

  for ($curturn = 0; $curturn<MAXTURNS; $curturn++) {
    my $num = int(rand(10))+1;
    print "turn: $curturn, num: $num\n";
    foreach my $cache_ref ($larry_cache, $robin_cache) {
      $cache_ref->{hit} = 0;
      my @cache = @{$cache_ref->{cache}};
      LOOP: foreach my $entry (@cache) {
        if ($entry->{value} == $num) {
          print "cache hit for $cache_ref->{name}\n";
          $entry->{hit} = $curturn;
          $cache_ref->{hit} = 1;
          last LOOP;
        }
      }
      if (!$cache_ref->{hit}) {
        print "cache miss for $cache_ref->{name}\n";
        if (@{$cache_ref->{cache}} >= 5) {
          remove($cache_ref);
        }
        insert($cache_ref, $num);
      }
      $cache_ref->{score} += $cache_ref->{hit};
      print Dumper($cache_ref);
    }
  }
  return ($larry_cache->{score} - $robin_cache->{score});
}

sub remove($) {
  my ($cache_ref) = @_;

  if ($cache_ref->{strategy} eq "lru") {
    my @sorted_cache = sort { $a->{hit} <=> $b->{hit} } @{$cache_ref->{cache}};
    my $removed = shift @sorted_cache;
    print "removed element $removed->{value}\n";
    $cache_ref->{cache} = \@sorted_cache;
  } elsif ($cache_ref->{strategy} eq "lifo") {
    my @sorted_cache = sort { $a->{inserted} <=> $b->{inserted} } @{$cache_ref->{cache}};
    my $removed = shift @sorted_cache;
    print "removed element $removed->{value}\n";
    $cache_ref->{cache} = \@sorted_cache;
  }
}
    
sub insert($$) {
  my ($cache_ref, $value) = @_;

  push @{$cache_ref->{cache}}, { "value" => $value, "inserted" => $curturn, "hit" => $curturn };
}

my $nof_samples = 0;
my $tot = 0;
while (1) {  
  my $score_diff = game();
  $tot += $score_diff;
  $nof_samples++;
  print $tot/$nof_samples, " ($score_diff)\n";
}

