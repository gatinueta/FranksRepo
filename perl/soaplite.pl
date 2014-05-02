#!/usr/bin/perl

use warnings;
use strict;
use 5.010;

use SOAP::Lite; # qw(trace);

my $arg = SOAP::Data->name(arg0 => 'Frank');
my $soap = SOAP::Lite                                             
    -> proxy('http://localhost:8080/Hubris');


$soap->on_action( sub { '' } ); #sub { "http://service.jaxws/#sayHello" });
$soap->autotype(0);
$soap->ns('http://service.jaxws/', 'jns');

my $response = $soap->call('sayHello', $arg);

die $response->faultstring if ($response->fault);
say "the result is ", $response->result;

__END__

 $soap->on_action( sub { "urn:HelloWorld#sayHello" });
        $soap->autotype(0);
        $soap->default_ns('urn:HelloWorld');

        my $som = $soap->call("sayHello",
           SOAP::Data->name('name')->value( 'Kutter' ),
           SOAP::Data->name('givenName')->value('Martin'),
       );


