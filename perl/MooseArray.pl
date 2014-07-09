package Stuff;
use Moose;

has 'options' => (
        traits  => ['Array'],
        is      => 'ro',
        isa     => 'ArrayRef[Str]',
        default => sub { [] },
        handles => {
            all_options    => 'elements',
            add_option     => 'push',
            map_options    => 'map',
            filter_options => 'grep',
            find_option    => 'first',
            get_option     => 'get',
            join_options   => 'join',
            count_options  => 'count',
            has_options    => 'count',
            has_no_options => 'is_empty',
            sorted_options => 'sort',
            splice_options => 'splice',
        },
);

no Moose;
1;

package main;
use strict;
use warnings;
use 5.010;
use Test::More;

my $stuff = Stuff->new();
$stuff->add_option('horse');
$stuff->add_option('cat');
$stuff->add_option('rabbit');
say $stuff->join_options(', ');

use Data::Dumper;
say Dumper ([$stuff->all_options], $stuff->options);

say "have ", $stuff->count_options, " options.";
splice [$stuff->all_options], 1, 1;
say "have ", $stuff->count_options, " options after splicing elements().";
splice @{ $stuff->options() }, 1, 1, 'dog', 'ant';
say "have ", $stuff->count_options, " options after splicing orig. array.";

$stuff->splice_options(1, 1, 'duck', 'parsley', 'crow');
say $stuff->join_options(', ');

say "your third option is ", $stuff->get_option(2);
say "first three-letter option is ", $stuff->find_option(sub { length ($_) == 3 });
