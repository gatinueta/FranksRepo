require LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
my @input = <>; 
my $response = $ua->post('http://localhost:8080/Hubris', Content_Type => 'text/xml', Content => join '', @content);

if ($response->is_success) {
    print $response->decoded_content;  # or whatever
}
else {
    die $response->status_line;
}
