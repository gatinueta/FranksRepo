use DB_File;

tie %hash,  'DB_File', "hash.db";


foreach (keys %hash) {
	print "$_ => ", $hash{$_}, "\n";
}

$hash{rand()} = rand();

untie %hash;

