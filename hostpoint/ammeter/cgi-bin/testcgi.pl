#!/usr/bin/perl -w
use CGI;
use strict;

my $q = CGI->new;
print $q->header,
      $q->start_html('hello world'),
      $q->h1('hello world'),
      $q->end_html;
 
