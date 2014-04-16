package BinTree::Node;

use Moose;

has 'value' => (is => 'rw', isa => 'Str');
has ['left', 'right', 'parent'] => (is => 'rw', isa => 'Maybe[BinTree::Node]');

package BinTree;

use Moose;
use 5.010;

has 'root' => (is => 'rw', isa => 'BinTree::Node');

sub insert {
    my ($self, @values) = @_;

    foreach my $value (@values) {
        #say "inserting $value...";
        _insert( $self->{root}, undef, BinTree::Node->new(value => $value));
    }
}

sub traverse {
    my ($self) = shift;
    say join ', ', _traverse( $self->root() );
}

sub search {
    my ($self, $value) = @_;

    return _search( $self->root(), $value ) ? 1 : 0;
}

sub _search {
    my ($root, $value) = @_;

    if (!$root) {
        return undef;
    } elsif ($root->value() eq $value) {
        return $root;
    } elsif ($root->value gt $value) {
        _search( $root->left(), $value );
    } else {
        _search( $root->right(), $value );
    }
}

sub delete {
    my ($self, @values) = @_;
 
    foreach my $value (@values) {
        _delete($self->{root}, $value );
    } 
}

sub _delete {
    our $root;
    *root = \$_[0];
    my $value = $_[1];
    if (!$root) {
        return;
    } elsif ($root->value() gt $value) {
        _delete($root->{left}, $value); 
    } elsif ($root->value() lt $value) {
        _delete($root->{right}, $value);
    } else {
        if (!$node->left()) {
            $root = $node->right());
        } else {
                $self->root($node->right());
            }
        } elsif (!$node->right()) {
            if ($node->parent()) {
                $node->parent()->left($node->left());
            } else {
                say "2b";
                $self->root($node->left());
            }
        } else {
            say 3;
            my $pre = $node->left();
            while ($pre->right()) {
                $pre = $pre->right();
            }
            $pre->parent()->right(undef);
            $node->value($pre->value());
        }
        say "deleted $value";
        $self->traverse();
      }
    }
}


sub _traverse {
    my $node = shift;
    my @arr = ();

    if ($node) {
        push @arr, _traverse($node->left());
        push @arr, $node->value();
        push @arr, _traverse($node->right());
    }
    return @arr;
}

sub _insert {
    our $root;
    *root = \$_[0];
    my ($r, $parent, $node) = @_;
    if (!$root) {
        $root = $node;
        if ($parent) {
            $root->parent($parent);
        }
    } elsif ($root->value() gt $node->value()) {
        _insert($root->{left}, $root, $node);
    } else {
        _insert($root->{right}, $root, $node);
    }
}

1;

package main;

my $tree = BinTree->new();
$tree->insert( '127', qw(apfel baum und ein paar andere) );
$tree->traverse();
#use Data::Dumper; 
#print Dumper $tree;

$tree->delete('baum');
say join ', ', map { "$_:" . $tree->search($_) } qw(apfel biren und ein baum 128 127);
$tree->delete(qw(baum paar und apfel 1000 128 127));
$tree->traverse();

