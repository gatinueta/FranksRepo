package Pos;

sub new ($$$) {
	my $self = {};
	my $class = shift;
	$self->{X} = shift;
	$self->{Y} = shift;

	bless $self, $class;
}

sub x {
	if (@_) {
		$self->{X} = shift;
	}
	return $self->{X};
}

sub y {
	if (@_) {
		$self->{Y} = shift;
	}
	return $self->{Y};
}

sub translate {
	my ($dx, $dy) = @_;

	$self->{X} += $dx;
	$self->{Y} += $dy;

	return $self;
}

package Board;

use constant SIZE = 8;

sub isOn {
	my $pos = shift;

	return ($pos->x() > 0 && $pos->y() < SIZE
		&& $pos->y() > 0 && $pos->y() < SIZE);
}
	
package Piece;

sub new {
	my $class = shift;
	my ($class, $color, $kind, $pos) = @_;

	my $self = {};

	$self->{COLOR} = $color;
	$self->{KIND} = $kind;
	$self->{POS} = $pos;

	bless $self, $class;

	return $self;
}

# TODO: pure virtual?
sub possMoves {
	return ();
}

package Queen;
use Piece;
@ISA = qw(Piece);

sub possMoves {
	my $self = shift;
	my $pos = ($self->{POS});

	foreach my $dx (-1,0,1) {
	    foreach my $dy (-1,0,1) {
		    if ($dx==0 && $dy==0) {
			    next;
		    }
	        foreach my $n (1..Board::SIZE-1)
		    my $newpos = $pos;
		    $newpos->translate($n*$dx,$n*$dy);

		    if (!Board::isOn($newpos)) {
			    break;
		    }

		    my $p = piece(Pos::new($tx,$ty));


		    push @moves, [$tx, $ty];

		    if (piece($tx, $ty)

	if (onboard($tx, $ty)) {
		push @moves, [$x,$y];
	}
	if (piece($tx,$ty) != PIECE_EMPTY) {
		break;
	}



