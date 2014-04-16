#!/usr/bin/perl -pi.bak
use warnings;
use strict;
use 5.010;

use open IO => ':raw';

s/(?<!\r)\n/\r\n/;

