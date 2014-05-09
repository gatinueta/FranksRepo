perldoc -f pos | perl -wne "my $lastpos; while (/(a\w*)/gp) { $lastpos = pos; print qq(${^PREMATCH}($1)[$lastpos]); } print substr ($_, $lastpos) if ($lastpos);"

