#!/usr/bin/perl -w
use strict;
use warnings;
use 5.010;

use Getopt::Long; 

*f = *Getopt::Long::setup_pa_args; 
eval { 
    f(undef);
    say 'successfully called internal function';
};

if ($@) { say 'error calling internal function'; }


