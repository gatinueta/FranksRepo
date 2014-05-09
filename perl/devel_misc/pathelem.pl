use File::Spec;
use feature qw(say);
use strict;

sub get_pathelem($) {
  my $dir = shift;

  my @pathcomp = ();

  while ($dir) {
    push @pathcomp, "pathelem:$dir";

    # remove all trailing slashes
    $dir =~ s|/*$||;

    # remove all trailing non-slashes
    $dir =~ s|[^/]*$||;

  }
  return @pathcomp;
}

my @comp = get_pathelem('//fileserver03/c$/Program Files/Duplex/Appl/ckgs.exe');
say join ", ", @comp;

