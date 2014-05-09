use Win32::GUI();

my $main = Win32::GUI::Window->new(
	-name => 'Main', 
	-text => 'Perl',
	-width => 200,
	-height => 200); 

my $popup = new Win32::GUI::Window(
                -name  => "popup",
                -title => "Popup Window",
                -pos   => [ 150, 150 ],
                -size  => [ 300, 200 ],
		-onClose => sub { return 1; }
        );

$main->Show(); 


$main->AddButton(
                -name => "Button1",
                -text => "Open popup window",
                -pos  => [ 10, 10 ],
		-onClick => sub { $popup->Show(); } 
        );
        
sub Popup_Terminate 
{ 
	$popup->Hide();
        return 1;
}


sub Main_Terminate {
        -1;
}

sub Popup_Close {
	$popup->Hide();
        return 1;
}

Win32::GUI::Dialog();



