drop table kontobewegungen;

create table kontobewegungen (
	buchungsdatum date not null, 
	text varchar(200), 
	belastung decimal(8,2), 
	gutschrift decimal(8,2), 
	valutadatum date, 
	saldo decimal(9,2) 
);

load data infile 'C:\\Users\\admin\\Downloads\\kontobewegungen_mysql.csv'
into table kontobewegungen
character set latin1
fields terminated by ','
escaped by '\\'
optionally enclosed by '"'
lines terminated by "\r\n";


