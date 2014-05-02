#!/usr/bin/perl

use warnings;
use strict;
use 5.010;

use SOAP::Lite; # qw(trace);

my $soap = SOAP::Lite                                             
    -> proxy('http://localhost:8080/Hubris')
    -> ns   ('http://service.jaxws/');

#$soap->on_action( sub { "http://service.jaxws/#sayHello" });
#$soap->autotype(0);

my $response = $soap->call('sayHello', SOAP::Data->name( arg0 => 'Frank'));

die $response->faultstring if ($response->fault);
say "the result is ", $response->result;

my $response2 = $soap->call('add',  
    SOAP::Data->name( arg0 => 3), 
    SOAP::Data->name( arg1 => 5)
);

die $response2->faultstring if ($response2->fault);
say "the result is ", $response2->result;

my $response3 = $soap->call('concat', 
    SOAP::Data->name( arg0 => 'one'),
    SOAP::Data->name( arg0 => 'two'),
    SOAP::Data->name( arg0 => 'three'),
    SOAP::Data->name( arg1 => '-'),
);

die $response3->faultstring if ($response3->fault);
say "the result is ", $response3->result;

__END__

 $soap->on_action( sub { "urn:HelloWorld#sayHello" });
        $soap->autotype(0);
        $soap->default_ns('urn:HelloWorld');

        my $som = $soap->call("sayHello",
           SOAP::Data->name('name')->value( 'Kutter' ),
           SOAP::Data->name('givenName')->value('Martin'),
       );


