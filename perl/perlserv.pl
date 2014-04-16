use strict;
use warnings;
use 5.010;

use HTTP::Daemon;
use HTTP::Status;

my $d = HTTP::Daemon->new || die;
say "Please contact me at: <URL:", $d->url, ">";
         
while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        if ($r->method eq 'GET' and $r->uri->path eq "/xyzzy") {
            # remember, this is *not* recommended practice :-)
            $c->send_file_response("/etc/passwd");
        } else {
             $c->send_error(RC_FORBIDDEN)
        }
    }
    $c->close;
    undef($c);
}

