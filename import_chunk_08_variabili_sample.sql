-- CHUNK 8: Campione di variabili (prime 10)
-- Nota: La tabella variabili ha una struttura molto complessa, 
-- includiamo un campione delle prime variabili più importanti
USE barbera_development;

INSERT INTO `variabili` (id, matrice_id, udm_item_id, nome_esteso, nome, simbolo, funzione, tipo, min, max, decimali, valori_possibili, note, created_at, updated_at) VALUES 
(1,3,1,'Acidità espressa in acido oleico','Acidità espressa in acido oleico','H','(L*J*K*282)/(10*I)','funzione',0.1,2,2,NULL,NULL,'2010-02-12 11:29:32','2010-02-22 08:39:50'),
(2,3,1,'Grammi olio (pesati)','Grammi olio (pesati)','I',NULL,'input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:31:47','2010-02-12 11:35:57'),
(3,3,NULL,'Normalità Soluzione NaOH (0.1)','Normalità Soluzione NaOH','J','','input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:32:54','2010-04-30 10:02:17'),
(4,3,NULL,'FATTORE CORREZIONE NaOH (1.0)','FATTORE CORREZIONE NaOH','K','','input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:38:00','2010-04-30 10:02:00'),
(5,3,4,'ml di  NaOH  impiegati','ml di  NaOH  impiegati','L',NULL,'input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:38:56','2010-02-12 11:41:00'),
(6,3,3,'Numero di Perossidi','Numero di Perossidi','M','O*P*1000/N','funzione',1,20,2,NULL,NULL,'2010-02-12 11:40:32','2010-02-22 08:39:50'),
(7,3,2,'Grammi olio (pesati)','Grammi olio (pesati)','N',NULL,'input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:41:47','2010-02-12 11:41:47'),
(8,3,4,'ml Soluzione Na2S2O3  impiegati','ml Soluzione Na2S2O3  impiegati','O',NULL,'input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:42:21','2010-02-12 11:42:21'),
(9,3,NULL,'Normalità Soluzione Na2S2O3  (0.01)','Normalità Soluzione Na2S2O3','P','','input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:42:57','2010-04-30 10:02:32'),
(10,3,NULL,'K232','K232 (K<small><sub>232</sub></small>)','Q','Z/Y','funzione',0.1,2500,3,NULL,NULL,'2010-02-12 11:44:54','2010-05-24 11:57:05');

SELECT 'Chunk 8: Campione variabili completato!' as Status;
