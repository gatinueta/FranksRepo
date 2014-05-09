use strict;

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

my @stat;

while ($stat_doc =~ /(\d+)\s+(\w+)\s+(.*)/g) {
  $stat[$1] = "$2: $3";
}

my @arr = stat $ARGV[0];

foreach my $i (0 .. $#arr) {
  print "$stat[$i]: $arr[$i]\n";
}

use File::stat;
use Data::Dumper;

print Dumper( stat $ARGV[0] );




