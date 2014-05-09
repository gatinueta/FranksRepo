CREATE TABLE POSTKONTO
(
  POST_KONTO_NR       DECIMAL(9)                 NOT NULL,
  STATUS              DECIMAL(1)                 NOT NULL,
  BEZEICHNUNG         VARCHAR(154),
  ZUSATZ_BEZEICHNUNG  VARCHAR(30),
  DRUCK_ORT_1         DECIMAL(4),
  DRUCK_ORT_2         DECIMAL(4),
  CHA_NR              DECIMAL(2),
  UPD_DATUM           DATE,
  WAEHRUNG            CHAR(3)              NOT NULL,
  POSTKONTOTYP        DECIMAL(2)                 NOT NULL,
  VERZEICHNISEINTRAG  DECIMAL(1)                 DEFAULT 1 NOT NULL,
  KUNDE_ID_STATUS     DECIMAL(1),
  MARKTSEGMENT        DECIMAL(2),
  IST_BAV_KUNDE       DECIMAL(1)                 DEFAULT 0 NOT NULL
);

create table postkonto_load as (select * from postkonto where 1=0);

select 'POSTKONTO','U',convert(p.post_konto_nr, CHAR) 
from postkonto p, postkonto_load l 
where p.post_konto_nr = l.post_konto_nr 
  and not ( p.status=l.status 
            and p.waehrung=l.waehrung 
            and p.marktsegment = l.marktsegment 
            and p.bezeichnung = l.bezeichnung 
            and p.postkontotyp = l.postkontotyp 
            and p.verzeichniseintrag = l.verzeichniseintrag 
            and p.ist_bav_kunde = l.ist_bav_kunde 
       ); 


