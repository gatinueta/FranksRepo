#!/usr/bin/perl 
use autodie;
use Charname 'explain';
use strict;
use warnings;
use 5.010;
use Unicode::Normalize 'compose';

binmode STDOUT, ":utf8"; 
opendir my $dh, "."; 
my ($raw_entry) = grep { /^fr/ } readdir $dh;

my $entry = $raw_entry;
say "length before decode: ", length $entry, " (bytes)";
utf8::decode($entry);
say "length after decode: ", length $entry, " (characters)";
explain($entry);
my $composed_entry = compose($entry);
say "length after compose: ", length $composed_entry, " (characters)";
explain($composed_entry);
