#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use Encode; 
use charnames ':full';
use CGI qw(-utf8);

my $q = CGI->new;
binmode STDOUT, ':utf8';

$SIG{__DIE__} = sub { print $q->pre(@_), "\n"; print $q->end_html; };

my $string  = $q->unescapeHTML($q->param('s')) || ' ';

print $q->header({-charset => 'UTF-8'},'text/html'),
    $q->start_html({-encoding => 'UTF-8', -title => "analysis of string '$string'"});

print $q->h1( 'analyzing string  ', $q->param('s') );
print $q->start_form({-action => '/cgi-bin/encodings_cgi.pl', -method => 'get', '-accept-charset' => 'UTF-8'}),
    'String (utf-8): ',
    $q->input({-type => 'text', -name => 's', -value => $q->param('s')}),
    $q->input({-type => 'submit', -value => 'Show Encoding'}),
    $q->end_form, "\n";

my @headers = ($q->th('Characters'));
push @headers,  map { $q->th($q->escapeHTML($_)) } split //, $string;


my $latin_encoded = encode ( 'iso-latin-1', $string); 
my @unicode_cp = ($q->td('Unicode code points'));
push @unicode_cp, map { $q->td(sprintf 'U+%04x',   ord) } split //, $string;

my @isolatin_cc = ($q->td('iso-latin-1 character codes'));

push @isolatin_cc, map { $q->td(sprintf '    %02x ', ord) } split //, $latin_encoded;

my @encoded_utf8 = map { encode_utf8 $_ } split //, $string;

my @utf8_chars;
foreach my $useq (@encoded_utf8) {
    push @utf8_chars, join '', map { sprintf '%02x', ord } split //, $useq;
}

my @utf8_strings = ($q->td('utf8 encoded string'));
    
push @utf8_strings, map { $q->td(sprintf '%6s', $_) } @utf8_chars;

my @charnames = ($q->td('charnames'));  
push @charnames, map { $q->td(charnames::viacode(ord $_)) } split //, $string;

print $q->table( {-border=>'1', -align=>'center'},
    $q->Tr(@headers), 
    $q->Tr(@unicode_cp),
    $q->Tr( @isolatin_cc),
    $q->Tr(@utf8_strings),
    $q->Tr(@charnames),
);


print $q->end_html;


