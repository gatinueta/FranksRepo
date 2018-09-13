CREATE TABLE zvprocessing (
    process varchar2(100), 
    status varchar2(100), 
    unit varchar2(10), 
    DESCription varchar2(200)
);

insert into zvprocessing ( process, status, unit, description ) values ('SETA','OPENED','DAY','Tag eröffnet auf Server');
insert into zvprocessing ( process, status, unit, description ) values ('CETA','OPENED','UOW','UOW eröffnet auf Client');
insert into zvprocessing ( process, status, unit, description ) values ('SETA','OPENED','UOW','UOW eröffnet auf Server');
insert into zvprocessing ( process, status, unit, description ) values ('SETA','CLOSED','UOW','UOW abgeschlossen auf Server');
insert into zvprocessing ( process, status, unit, description ) values ('CETA','CLOSED','UOW','UOW abgeschlossen auf Client (Stapelabschluss, Ende Programm)');
insert into zvprocessing ( process, status, unit, description ) values ('SETA','NABA','UOW','UOW abgeschlossen auf Server, NABA ausstehend');
insert into zvprocessing ( process, status, unit, description ) values ('SETA','NABA','DAY','Tag abgeschlossen auf Server, NABA ausstehend');
insert into zvprocessing ( process, status, unit, description ) values ('SETA','READY','UOW','UOW abgeschlossen auf Server, Alle UOW-Daten bereit, werden gesendet an KR');
insert into zvprocessing ( process, status, unit, description ) values ('SETA','READY','DAY','Tag abgeschlossen auf Server, bereit auf KR');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','RECEIVED','UOW','UOW empfangen auf KR');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','RECEIVED','DAY','Tagesabschluss empfangen auf KR');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','VALIDATED','UOW','UOW (Vollständigkeit, md5 hash) validiert auf KR');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','NOT_NEEDED','UOW','UOW wird nicht weiter verarbeitet auf dem KR (Nicht produktiver Flow)');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','VALIDATED','DAY','Tag validiert auf KR');
insert into zvprocessing ( process, status, unit, description ) values ('DAB%','READY','TX','Belegbild bereit zum Senden an DAB');
insert into zvprocessing ( process, status, unit, description ) values ('JURA','READY','TX','Belegbild bereit zum Senden an JURA');
insert into zvprocessing ( process, status, unit, description ) values ('DAB%','NOT_NEEDED','TX','Kein Belegbild an DAB notwendig');
insert into zvprocessing ( process, status, unit, description ) values ('JURA','NOT_NEEDED','TX','Kein Belegbild an JURA notwendig');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','WAIT_IMAGE_ACK','UOW','Warten auf Bildversand DAB');
insert into zvprocessing ( process, status, unit, description ) values ('ARCH4','READY','DAY','Kassenlogextrakt JURA bereit zum Versand');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','WAIT_FOR_ACKS','DAY','Warten auf Quittierungen (ISYMV, FORZA, DAB, JURA)');
insert into zvprocessing ( process, status, unit, description ) values ('DAB%','SENT','TX','Belegbild gesendet an DAB');
insert into zvprocessing ( process, status, unit, description ) values ('ARCH4','SENT','DAY','Kassenlogextrakt gesendet an JURA');
insert into zvprocessing ( process, status, unit, description ) values ('DAB_BW','ACKD','TX','Belegbild von DAB quittiert');
insert into zvprocessing ( process, status, unit, description ) values ('ARCH4','ACKD','DAY','Alle Kassenlog-Extrakts quittiert von JURA');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','IMAGES_CONFIRMED','UOW','Alle Bilder quittiert von DAB');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','WAIT_FOR_DAILY_CLOSING','UOW','Transaktionsversand: Warten auf Tagesabschluss');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','CREATE_PAYMENTS','UOW','Bereit für Transaktionsversand ISYMV/FORZA');
insert into zvprocessing ( process, status, unit, description ) values ('ISYMV','SEND_UOW','UOW','Payments für UOW bereit zum Senden');
insert into zvprocessing ( process, status, unit, description ) values ('FORZA','SEND_UOW','UOW','Payments für UOW bereit zum Senden');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','WAIT_FOR_PAYMENT_ACK','UOW','Warten auf Quittierung von FORZA / ISYMV');
insert into zvprocessing ( process, status, unit, description ) values ('ISYMV','SENT','UOW','Buchungsfile für UOW verschickt');
insert into zvprocessing ( process, status, unit, description ) values ('FORZA','SENT','UOW','Buchungsfile für UOW verschickt');
insert into zvprocessing ( process, status, unit, description ) values ('JURA','SENT','TX','Belegbild an JURA verschickt');
insert into zvprocessing ( process, status, unit, description ) values ('ISYMV','ACKD','UOW','Alle Buchungsfiles für UOW bestätigt.');
insert into zvprocessing ( process, status, unit, description ) values ('FORZA','ACKD','UOW','Alle Buchungsfiles für UOW bestätigt.');
insert into zvprocessing ( process, status, unit, description ) values ('DAB%','ACKD','TX','Belegbild von DAB quittiert');
insert into zvprocessing ( process, status, unit, description ) values ('JURA','ACKD','TX','Belegbild von JURA quittiert');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','UOW_CONFIRMED','UOW','Buchungen von UOW quittiert');
insert into zvprocessing ( process, status, unit, description ) values ('CONSOLIDATION','EOD','DAY','Quittierungen für Tag komplett: Bereit für EOD');
insert into zvprocessing ( process, status, unit, description ) values ('SUMMARIZATION','DONE','DAY','ZV_KUMULIERT berechnet auf DSS');
insert into zvprocessing ( process, status, unit, description ) values ('ISYMV','NOT_NEEDED','UOW','Kein Buchungsfile für ISYMV notwendig (leer oder nichtproduktiver Flow)');
insert into zvprocessing ( process, status, unit, description ) values ('FORZA','NOT_NEEDED','UOW','Kein Buchungsfile für FORZA notwendig (leer oder nichtproduktiver Flow)');

commit;
