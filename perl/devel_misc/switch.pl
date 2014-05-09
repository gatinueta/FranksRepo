use feature ("switch", "say");
use strict;

foreach ("silly", "1goers", "201", "300", "the1andonly") { 
  when (/1/) { 
    say "there was a one in $_"; 
  } 
  default { 
    say "there was no one in $_"; 
  } 
}

