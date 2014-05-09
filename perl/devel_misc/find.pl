#! C:\Perl\bin\perl.exe -w
    eval 'exec C:\Perl\bin\perl.exe -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell

use strict;
my ($ccflags, $optimize, $libs);
BEGIN {
 use Config;
 
 ($ccflags, $optimize, $libs) = 
  ($Config{ccflags}, $Config{optimize}, $Config{libs});
 
 $ccflags =~ s/-MD/-MT/g;
 $optimize =~ s/-MD/-MT/g;
 $libs =~ s/msvcrt/libcmt/ig;
}
 
use Inline ('C' => Config => 
 CCFLAGS => "$ccflags",
 OPTIMIZE => "$optimize",
 LIBS => "$libs"
);
 
use Inline 'C';
use File::Find ();

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

sub wanted;

my $stat_doc = << 'EOF';
    0 dev      device number of filesystem
    1 ino      inode number
    2 mode     file mode  (type and permissions)
    3 nlink    number of (hard) links to the file
    4 uid      numeric user ID of file's owner
    5 gid      numeric group ID of file's owner
    6 rdev     the device identifier (special files only)
    7 size     total size of file, in bytes
    8 atime    last access time in seconds since the epoch
    9 mtime    last modify time in seconds since the epoch
   10 ctime    inode change time in seconds since the epoch (*)
   11 blksize  preferred block size for file system I/O
   12 blocks   actual number of blocks allocated
EOF

my @stat_info;
foreach my $stat_line (split /\n/, $stat_doc) {
	if ($stat_line =~ /\s*(\d+)\s+(\w+)\s+(.*)$/) {
		$stat_info[$1] = "$2 $3";
	} else {
		warn "can't read stat doc line $stat_line\n";
	}	
}

		
my $dir = shift || '.';
my $minsize = shift || 10000;


# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, $dir);
exit;


sub wanted {

    my @arr = lstat($_) or return;
    -f _ or return;
   if ($name =~ /small/ or $name =~ /thumbs/) {
	   print "$name\n";
	   unlink $_;
   }
    #print "WinAPI file size: ", WinApiFileSize($_), "\n";    
}


__END__    
__C__


long WinApiFileSize(const char *fileName)
{
    BOOL                        fOk;
    WIN32_FILE_ATTRIBUTE_DATA   fileInfo;

    if (NULL == fileName)
        return -1;

    fOk = GetFileAttributesEx(fileName, GetFileExInfoStandard, (void*)&fileInfo);
    if (!fOk)
        return -1;
    assert(0 == fileInfo.nFileSizeHigh);
    return (long)fileInfo.nFileSizeLow;
}


