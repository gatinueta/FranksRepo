use warnings; 
use strict;

use Tk;
use Tk::PNG;

our $mw = new MainWindow( -title => "Tk Chess" );
our $board;

use constant PIXWIDTH => 600;
use constant PIXHEIGHT => 600;

use constant HEIGHT => 8;
use constant WIDTH => 8;

my $cellwidth = PIXWIDTH/WIDTH;
my $cellheight = PIXHEIGHT/HEIGHT;

package Board;


sub new {
  my $type = shift;
  my %params = @_;
  my $self = {};
  $self->{fields} = [];
  $self->{deleted_items} = [];
  $self->{its_whites_turn} = 1;
  $self->{fields}->[main::WIDTH*main::HEIGHT-1] = undef;
  $self->{moves} = [];

  bless $self, $type;
}

sub ison {
  my ($self, $coords) = @_;

  my ($x, $y) = @$coords;
  return (0 <= $x and $x<main::WIDTH and 0<=$y and $y<main::HEIGHT);
}

sub checkstate {
  my ($self, $coords) = @_;

  my ($x, $y) = @$coords;

  if (!ison($self,$coords)) {
    return undef;
  } else {
    my $piece = $self->field($coords);

    if (!defined($piece)) {
      return "empty";
    } else {
      return ref $piece;
    }
  }
}

sub field {
  my $self = shift;
  my $coords = shift;
  my ($x, $y) = @$coords;
  if (@_ > 0) {
    $self->{fields}->[$x+$y*main::WIDTH] = shift();
  } else {
    return $self->{fields}->[$x+$y*main::WIDTH];
  }
}

sub add_deleted_item {
  my ($self, $deleted_item) = @_;

  push @{$self->{deleted_items}}, $deleted_item;
}

#sub remove_deleted_item {
#  my ($self, $undeleted_item) = @_;
#
#  foreach (@{$self->{deleted_items}}) {

sub deleted_items {
  my ($self) = @_;

  return @{$self->{deleted_items}};
}

sub make_move {
  my ($self, $from_pos, $to_pos) = @_;
  my $target_piece = $self->field($to_pos);
  if (defined($target_piece)) {
    $self->add_deleted_item($target_piece);
  }

  my $piece = $self->field($from_pos);
  $self->field($to_pos, $piece);
  my $former_ego = $piece->moved($to_pos);
  $self->field($from_pos, undef );

  my $move = [$from_pos, $to_pos, $target_piece, $former_ego];

  push @{$self->{moves}}, $move;
  use Data::Dumper;
  main::signal_gui("moved", Dumper $move);

  $self->{its_whites_turn} = not $self->{its_whites_turn};
}

sub takeback_move {
  my ($self) = @_;
  my $last_move = pop @{$self->{moves}};

  my ($from_pos, $to_pos, $target_piece, $former_ego) = @{$last_move};

  my $piece = $self->field($to_pos);

  $self->field($from_pos, $piece);
  $piece->x($from_pos->[0]);
  $piece->y($from_pos->[1]);
  $self->field($to_pos, $target_piece);
  
  if (defined($target_piece)) {
    $target_piece->x($to_pos->[0]);
    $target_piece->y($to_pos->[1]);
    $target_piece->death_fuse(20);
    print "revived a frigging ", ref $target_piece, "\n";
  }

  if (defined($former_ego)) {
    bless $piece, $former_ego;
    main::signal_gui("deleted", $piece->image_item());
    $piece->image_item(undef);
  }
  $self->{its_whites_turn} = not $self->{its_whites_turn};
}


sub its_whites_turn {
  my ($self) = @_;
  return $self->{its_whites_turn};
}


package Piece;
use Class::Struct;

struct( color => '$', x => '$', y => '$', shiftx => '$', shifty => '$', image_item => '$', death_fuse => '$' );

sub legal_targets {
  return ();
}

sub get_image {
  return undef;
}

sub moved {
  return undef;
}


package King;

our @ISA = qw(Piece);

my $image_w_king =  $mw->Photo( 
  -file => "koenig.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";

my $image_b_king =  $mw->Photo( 
  -file => "koenig_schwarz.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";

sub get_image {
  my ($self) = @_;

  return $self->color() eq "white" ? $image_w_king : $image_b_king;
}

my @king_moves = ( [1,0], [0,1], [-1,0], [0,-1], [1,1], [-1,1], [1,-1], [-1,-1] );



sub legal_targets {
  my ($self) = @_;

  my @targets = ();

  foreach my $move (@king_moves) {
    my $target_field = [$self->x()+$move->[0], $self->y()+$move->[1]];
      if ($board->ison($target_field)) {
        my $target_piece = $board->field($target_field);

        if (!defined($target_piece) or not $target_piece->color() eq $self->color()) {
          push @targets, $target_field;
        }
      }
  }
  return @targets;
}


package Queen;
our @ISA = qw(Piece);

my $image_w_queen =  $mw->Photo( 
  -file => "queen.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";

my $image_b_queen =  $mw->Photo( 
  -file => "queen_schwarz.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";

sub get_image {
  my ($self) = @_;

  return $self->color() eq "white" ? $image_w_queen : $image_b_queen;
}

my @queen_basic_moves = ( [1,0], [0,1], [-1,0], [0,-1], [1,1], [-1,1], [1,-1], [-1,-1] );

sub legal_targets {
  my ($self) = @_;

  my @targets = ();

  foreach my $basic_move (@queen_basic_moves) {
    ONE_DIR:
    for (my $factor = 1;;$factor++) {
      my $target_field = [$self->x()+$basic_move->[0]*$factor, $self->y()+$basic_move->[1]*$factor];
      if (!$board->ison($target_field)) {
        last ONE_DIR;
      } else {
        my $target_piece = $board->field($target_field);

        if (!defined($target_piece)) {
          push @targets, $target_field;
        } elsif ($target_piece->color() eq $self->color()) {
          last ONE_DIR;
        } else {
          push @targets, $target_field;
          last ONE_DIR;
        }
      }
    }
  }
  use Data::Dumper;
  return @targets;
}


package Knight;

our @ISA = qw(Piece);

my $image_w_knight = $mw->Photo( 
  -file => "horse.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";
my $image_b_knight = $mw->Photo( 
  -file => "pferd.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";

sub get_image {
  my ($self) = @_;

  return $self->color() eq "white" ? $image_w_knight : $image_b_knight;
}


my @knights_moves = ( [1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1] );

sub legal_targets {
  my ($self) = @_;
  my @targets = ();
  foreach my $move (@knights_moves) {
    my $target = [$self->x() + $move->[0], $self->y() + $move->[1]];
    if ($board->ison($target)) {
      my $targetfield = $board->field($target);
      if (!defined($targetfield) or not $targetfield->color() eq $self->color()) {
        push @targets, $target;
      }
    }
  }
  return @targets;
}

1;

package Pawn;

our @ISA = qw(Piece);

my $image_w_pawn = $mw->Photo( 
  -file => "bauer.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";
my $image_b_pawn = $mw->Photo( 
  -file => "bauer_links.png", -width => $cellwidth, -height => $cellheight
) or die "sorry: $!";

sub is_on_original_pos {
  my ($self) = @_;

  return (($self->color() eq "white" and $self->y() == 1) 
           or
          ($self->color() eq "black" and $self->y() == main::HEIGHT-2)
         );
}

sub legal_targets {
  my ($self) = @_;
  my @targets = ();

  my $normal_target = [$self->x(), $self->y()+($self->color() eq "white" ? 1 : -1)];

  if ($main::board->checkstate($normal_target) eq "empty") {
     push @targets, $normal_target;
     if ($self->is_on_original_pos()) {
       my $twostep_target = [$self->x(), $self->y()+($self->color() eq "white" ? 2 : -2)];

       if ($main::board->checkstate($twostep_target) eq "empty") {
         push @targets, $twostep_target;
       }
     }
   }

  foreach my $lr (1, -1) {
    my $capture_target =  [$self->x()+$lr, $self->y()+($self->color() eq "white" ? 1 : -1)];

    if ($board->ison($normal_target)) {
     my $targetfield = $board->field($capture_target); 
      if (defined($targetfield) and not $targetfield->color() eq $self->color()) {
        push @targets, $capture_target;
      }
    }
  }

  return @targets;
}

sub get_image {
  my ($self) = @_;

  return $self->color() eq "white" ? $image_w_pawn : $image_b_pawn;
}

sub moved {
  my ($self, $coords) = @_;

  if (
      ($self->color() eq "white" and $self->y() == main::HEIGHT-1)
        or
      ($self->color() eq "black" and $self->y() == 0)
    ) 
  {
    # wonderful, this must be perl
    bless $self, "Queen";
    main::signal_gui("deleted", $self->image_item());
    $self->image_item(undef);
    return "Pawn";
  } else {
    return undef;
  }
}


1;

package main;


$board = new Board();

my ($canvas, $label);

sub move_and_redraw {
  my $canvas = shift;

  move();
  redraw( $canvas );
}

sub signal_gui {
  my ($action_type, @args) = @_;

  if ($action_type eq "deleted") {
    $canvas->itemconfigure($args[0], -state => "hidden" );
  } elsif ($action_type eq "moved") {
    $label->configure(-text => $args[0]);
  }
}

sub move {
  for (my $nof_tries=0; $nof_tries<1000; $nof_tries++) {
    my $x = int(rand(WIDTH));
    my $y = int(rand(HEIGHT));

    my $piece = $board->field([$x,$y]);

    if (defined($piece) and $board->its_whites_turn() == ($piece->color() eq "white")) {
      my @legal_targets = $piece->legal_targets();

      my $nof_legal_targets = @legal_targets;
      if ($nof_legal_targets > 0) {
        my $i = int(rand($nof_legal_targets));
        
        my ($tx, $ty) = @{$legal_targets[$i]};

        $piece->x($tx);
        $piece->y($ty);
        $piece->shiftx($cellwidth*($x-$tx));
        $piece->shifty($cellwidth*($y-$ty));

        $board->make_move([$x,$y],[$tx,$ty]);
        return;
      }
    }
  }
}


sub redraw {
  my $canvas = shift;

  foreach my $piece ($board->deleted_items()) {
    my $death_fuse = $piece->death_fuse();

    if ($death_fuse == 0) {
      $canvas->itemconfigure($piece->image_item(), -state => "hidden" );
    }
 
    if ($death_fuse >= 0) {
      $piece->death_fuse($death_fuse-1);
    }
  }

  foreach my $y (0..HEIGHT-1) {
    foreach my $x (0..WIDTH-1) {
      my $piece = $board->field([$x,$y]);
      if (defined($piece)) {
        drawpiece( $canvas, [$x,$y], $piece );
      }
    }
  }


}

my %rectangles = ();

sub drawbackground($$) {
    my ($canvas, $coords) = @_;
    my ($x, $y) = @{$coords};
    my ($posx, $posy) = ($x*$cellwidth, $y*$cellheight);
    
    if (!defined($rectangles{$x,$y})) {
      $rectangles{$x,$y} = $canvas->createRectangle($posx, $posy, $posx+$cellwidth, $posy+$cellheight, -fill => (($x+$y)%2==0 ? "white" : "light grey"));
    }
}

use constant INCR => 10;

sub drawpiece($$$) {
    my ($canvas, $coords, $piece) = @_;
    my ($x, $y) = @{$coords};
    my $type = ref $piece;
    my ($color, $shiftx, $shifty)  = ($piece->color(), $piece->shiftx(), $piece->shifty());
    my ($posx, $posy) = ($x*$cellwidth, $y*$cellheight);
    
    #$canvas->createRectangle($posx, $posy, $posx+$cellwidth, $posy+$cellheight, -fill => (($x+$y)%2==0 ? "white" : "light grey"));
    my $image_item = $piece->image_item();
    if (!defined($image_item)) {
      my $image = $piece->get_image();
      $image_item = $canvas->createImage($posx+$shiftx, $posy+$shifty, -image => $image, -anchor => "nw");
      $piece->image_item($image_item);
    } else {
      $canvas->coords( $image_item, $posx+$shiftx, $posy+$shifty);
    }

    if (abs($shiftx)<INCR) {
      $piece->shiftx(0);
    } elsif ($shiftx > 0) {
      $piece->shiftx($shiftx-&INCR);
    } elsif ($shiftx < 0) {
      $piece->shiftx($shiftx+&INCR);
    }
    if (abs($shifty) < INCR) {
      $piece->shifty(0);
    } elsif ($shifty > 0) {
      $piece->shifty($shifty-&INCR);
    } elsif ($shifty < 0) {
      $piece->shifty($shifty+&INCR);
    }
}

$canvas = $mw->Canvas(
  -width => PIXWIDTH, -height => PIXHEIGHT, -background => "white"
)->pack();

use Data::Dumper;

my $move_button = $mw->Button( -command => sub { main::move(); }, -text => "Move" )->pack();
my $takeback_button = $mw->Button( -command => sub { $board->takeback_move() }, -text => "Take back" )->pack();

$label = $mw->Label( -text => "Tk Chess" )->pack();

foreach my $y (0..HEIGHT-1) {
  foreach my $x (0..WIDTH-1) {
    my $piece = $board->field([$x,$y]);
    if (!defined($piece)) {
      drawbackground( $canvas, [$x,$y] );
    }
  }
}

foreach my $y (0..HEIGHT-1) {
  foreach my $x (0..WIDTH-1) {
    my ($type, $color);

    if ($y==0) {
      if (($x+$y)%2==0) {
        $type = "Knight";
        $color = "white";
      } elsif ($x>=WIDTH-2) {
        $type = "King";
        $color = "white";
      } else {
        $type = "empty";
      }
    } 
    elsif ($y==1) {
      $type = "Pawn";
      $color = "white";
    }
    elsif ($y==HEIGHT-1) {
      if (($x+$y)%2==1) {
        $type = "Knight";
        $color = "black";
      } elsif ($x<=1) {
        $type = "King";
        $color = "black"
      } else {
        $type = "empty";
      }
    }
    elsif ($y==HEIGHT-2) {
      $type = "Pawn";
      $color = "black";
    } else {
      $type = "empty";
    }

    my $piece;
    
    if ($type eq "empty") {
      $piece = undef;
    } else {
      $piece = new $type(color => $color, x => $x, y => $y, shiftx => 0, shifty => 0, death_fuse => 20);
       $board->field([$x,$y], $piece);
  
      drawpiece( $canvas, [$x,$y], $piece );
    }  
  }
}


#my $MOVE_DELAY = 1000;

#$mw->repeat($MOVE_DELAY, \&move, $canvas);

my $REDRAW_DELAY = 10;

$mw->repeat($REDRAW_DELAY, \&redraw, $canvas);

$mw->MainLoop();

1;

