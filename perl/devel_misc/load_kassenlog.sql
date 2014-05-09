load data infile 'C:/Users/admin/devel/storno_mysql.dat'
into table kassenlog
fields terminated by ';'
optionally enclosed by '"'
lines terminated by "\r\n";

