use strict;

sub berechne_pi($) {
  my $tropfenzahl = shift;
  my $gesamt = $tropfenzahl;

  my $innerhalb = 0;
  while ($tropfenzahl > 0) { 
    # generiere Tropfen und addiere je nach Zugehörigkeit
    my $dotx = rand(1);
    my $doty = rand(1);
 
    if ($dotx*$dotx + $doty*$doty <= 1) {
      # Punkt liegt innerhalb des Kreises
      $innerhalb++;
    } else {
      # Punkt liegt außerhalb des Kreises
    }
 
    $tropfenzahl--;
  }
 
  my $pi = 4*$innerhalb/$gesamt;
  return $pi;
}

print berechne_pi(1000000), "\n";

