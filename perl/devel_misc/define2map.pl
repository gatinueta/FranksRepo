# c:\Program Files\Microsoft SDKs\Windows\v6.0A\Include\WinUser.h
while(<>) {
	# numeric
	if (/\s*#define\s+(WM_\w+)\s+(0x.*)$/) {
	       print qq/{ $2, "$1" },\n/;
        }
}

