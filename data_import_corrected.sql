-- Importazione dati corretti per il database Barbera
-- Questo file è stato corretto per essere compatibile con la struttura attuale del database

USE barbera_development;

-- Disabilita i controlli delle chiavi esterne temporaneamente
SET FOREIGN_KEY_CHECKS = 0;

--
-- Svuota le tabelle esistenti (solo i dati, non la struttura)
--
DELETE FROM variabili;
DELETE FROM tipologie;
DELETE FROM prove;
DELETE FROM parametri;
DELETE FROM matrici;
DELETE FROM clienti;

-- Reset degli auto_increment
ALTER TABLE clienti AUTO_INCREMENT = 1;
ALTER TABLE matrici AUTO_INCREMENT = 1;
ALTER TABLE parametri AUTO_INCREMENT = 1;
ALTER TABLE prove AUTO_INCREMENT = 1;
ALTER TABLE tipologie AUTO_INCREMENT = 1;
ALTER TABLE variabili AUTO_INCREMENT = 1;

--
-- Dumping data for table `clienti`
-- Adattato alla struttura attuale del database
--

INSERT INTO `clienti` (id, nome, denominazione, codice, indirizzo, cap, comune, provincia, partita_iva, codice_fiscale, tel, fax, email_per_notifiche, cellulare_per_sms, titolare_cellulare, note, created_at, updated_at, cellulare_per_sms_2, titolare_cellulare_2) VALUES 
(3,'Bono e Ditta','Bono e Ditta S.p.a.','1','Via Selinunte, n. 718','91021','Campobello Di Mazara','TP','00059390815',NULL,'0924 - 47849/47766','0924 - 48011','ceblab@tiscali.it',NULL,NULL,NULL,'2010-02-18 11:48:51','2010-05-24 11:47:39',NULL,NULL),
(4,'Colomba Bianca','Cantine Colomba Bianca Soc. Coop. A.r.l.','2','C/da Giudeo Minore','91026','Mazara Del Vallo','TP','00241940816',NULL,'0923/947636','0923/947636 ','colombabianca@interfree.it ','3396802991','Enologo Ferracane','333/6995394 cell. cantina ','2010-02-18 12:04:19','2010-02-19 11:08:46','3336995360','cellulare cantina'),
(5,'Castelvetrano','Cantina Sociale Castelvetrano','3','Via Partanna, ang. Via Airone','91022','Castelvetrano','TP','00063090815',NULL,'0924 - 902731','0924 - 902964','info@cantinacastelvetrano.it ','3298028291','Enologo Montalto Maurizio',NULL,'2010-02-18 12:10:50','2010-02-19 10:50:52',NULL,NULL),
(6,'Santa Ninfa','Cantina Sociale Santa Ninfa','4','C/da Magazzinazzi','91029','Santa Ninfa','TP','00062810817',NULL,'0924 - 61170','0924 - 61170','info@cantinasantaninfa.it','339/4159031','Enologo Maggio Diego',NULL,'2010-02-18 12:16:37','2010-02-19 11:01:18',NULL,NULL),
(7,'Zangara','Cantina Sociale Zangara','5','S.P. 17','91022','Castelvetrano','TP','00063160816',NULL,'0924 - 87187','0924 - 87187','info@cantinazangara.com ',NULL,NULL,NULL,'2010-02-18 12:52:08','2010-02-19 11:03:44',NULL,NULL),
(8,'Cassarà','Enologica Cassarà S.r.l.','6','C/da Fiume S.S. 113','91011','Alcamo','TP','01969390812',NULL,'0924 - 502911','0924 - 503912','info@vinicassara.it','336401689','Enologo Parrinello',NULL,'2010-02-19 11:07:41','2010-02-19 11:07:41',NULL,NULL),
(9,'Fiumefreddo','Soc. Coop. Agricola Fiumefreddo','7','C/da Coda di Volpe','91011','Alcamo','TP','00091970814',NULL,'0924 - 24547','0924 - 28944','cantinafiumefreddo-@libero.it','335462860','Enologo Simone Milazzo',NULL,'2010-02-19 11:23:45','2010-02-19 11:23:45',NULL,NULL),
(10,'Foraci','Cantine Foraci S.r.l.','8','C/da Serroni','91026','Mazara Del Vallo','TP','01459800817',NULL,'0923 - 906332','0923 - 907219','info@cantineforaci.com ','3358029745','Enologo Piero Giacalone',NULL,'2010-02-19 11:31:06','2010-02-19 11:31:06',NULL,NULL),
(11,'Valle Belice','Cantina  Valle Belice Soc. Coop. Agr.','9','C/da Dagala della Donna','91020','Poggioreale','TP','00068550813',NULL,'0924/75612','0924/75612','ninopalmeri@vinientella.com','3338329356','Enologo Nino Palmeri',NULL,'2010-02-19 11:33:15','2010-02-19 11:33:15',NULL,NULL),
(12,'P.V.R.','Coop. Agr. "Produttori Vinicoli Riuniti " Cantina Sociale','10','Via Circonvallazione, sn','91026','Mazara Del Vallo','TP','00060480811',NULL,'0923 - 941228','0923 - 941264',NULL,'3474501695','Enologo Russo',NULL,'2010-02-19 11:57:32','2010-02-19 11:57:32',NULL,NULL),
(13,'Cellaro','Cantina Cellaro Sociale Cooperativa Agricola','11','C/da Anguilla - SS 188','92017','Sambuca Di Sicilia','AG','00071320840',NULL,'0925 - 941230','0925 - 942944','vini@cellaro.it ',NULL,'Enologo Vito Giovinco',NULL,'2010-02-19 12:03:05','2010-02-19 12:03:05',NULL,NULL),
(14,'Saturnia','Saturnia Soc.Coop. Agricola','12','C/da Camarro','91028','Partanna','TP','00063080816',NULL,'0924 - 49520','0924 - 87373','coop.saturnia@libero.it',NULL,'Enologo Figuccia',NULL,'2010-02-19 12:07:39','2010-02-19 12:07:39',NULL,NULL),
(15,'Enopolio','Produt. Vitiv. Enopolio di Castellammare del Golfo','13','Via Ponte Bagni, 20','91014','Castellammare Del Golfo','TP','00299090811',NULL,'0924/32195','0924/32195','info@enopoliovini.it ','3397192193','Enologo Palermo',NULL,'2010-02-19 12:12:41','2010-02-19 12:12:41',NULL,NULL),
(16,'Castellino','Coop. Agr. Castellino','14','C/da Fiume S.S. 113 Km 335,300','91011','Alcamo','TP','00609350814',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-19 12:19:14','2010-02-19 12:19:14',NULL,NULL),
(17,'Baglio del Cristo','Baglio del Cristo di Campobello Soc. Agr. a.r.l.','15','C/da Favarotta S.S. 123 Km. 19+200','92021','Campobello Di Licata','AG','02190950846',NULL,'0922-877709','0922-877709','lentinigiu@libero.it','3335323514','Enologo Lentini',NULL,'2010-02-19 12:22:07','2010-02-19 12:22:07',NULL,NULL),
(18,'Alicos','Società Agricola Alicos S.a.s. di Palermo Gaetano','16','Via M.Cremona, 21','91018','Salemi','TP','02177550817',NULL,'0924/983348','0924/983348','alicos@sifree.it ;info@alicos.it;palermo.gaetano@tiscali.it','360870531','Giovanni Barbaro',NULL,'2010-02-19 12:25:53','2010-02-19 12:25:53',NULL,NULL),
(19,'Di Maria','Az. Agr. Di Maria Antonino','17','Via G.Marconi, 86','91021','Campobello Di Mazara','TP','01486760810',NULL,'0924 - 47709',NULL,NULL,'3391206170','Di Maria Antonino',NULL,'2010-02-19 12:28:00','2010-02-19 12:28:00',NULL,NULL),
(20,'Casale del Frate','Az. Agr. Casale del Frate','18','Via Garibaldi','91028','Partanna','TP','01639030814',NULL,NULL,NULL,'francogambina@tiscali.it','3931985331','Agronomo Gambina Franco',NULL,'2010-02-19 12:34:34','2010-02-19 12:34:34',NULL,NULL);

--
-- Dumping data for table `matrici`
--

INSERT INTO `matrici` VALUES 
(3,'Olio','Olio','2010-02-12 11:18:36','2010-05-08 12:04:46'),
(4,'Suolo','Suolo','2010-02-12 12:13:08','2010-05-08 12:04:35'),
(5,'Enologia','Enologia (Vino-mosti)','2010-02-12 16:42:43','2010-02-15 16:18:56'),
(6,'Concime','Concime','2010-05-07 18:02:02','2010-05-07 18:02:02'),
(7,'Terreno','Terreno','2010-05-08 12:05:49','2010-05-08 12:05:49');

--
-- Dumping data for table `parametri`
--

INSERT INTO `parametri` VALUES 
(1,'dati_stampa_intestazione ','Dati_stampa_intestazione',NULL,'<img alt="" border="0" src="/images/rdp_intestazione.jpg" /></a>\r\n','2010-02-28 23:18:41','2010-04-27 11:23:59'),
(2,'lab_comune','Lab_comune',NULL,'Campobello di Mazara','2010-02-28 23:19:05','2010-02-28 23:19:05'),
(3,'rdp_stampa_intestazione','Rdp_stampa_intestazione',NULL,'<img alt="" border="0" src="/images/rdp_intestazione.jpg" /></a>\n','2010-02-28 23:19:26','2010-03-01 13:35:20'),
(4,'rdp_stampa_pie_pagina_3',NULL,NULL,'Autorizzazione MIPAF al rilascio dei certificati validi ai fini della commercializzazione ed esportazione dei vini (prot. 60662 del 13/03/1996)\nAutorizzazione MIPAF al rilascio dei certificati validi ai fini della commercializzazione ed esportazione degli oli (prot. 60141 del 15/12/2003)\n','2010-03-01 12:13:45','2010-05-19 15:31:13'),
(5,'dati_stampa_titolo','Titolo stampa anteprima analis',NULL,'Anteprima Rapporto di Prova','2010-03-01 12:15:35','2010-03-01 13:00:47'),
(6,'rdp_stampa_frase_per_supplemento','Frase per supplementi','compare SOLO se il Rdp è un supplemento','Il presente supplemento annulla e sostituisce il rapporto di prova a cui fa riferimento','2010-03-01 17:07:25','2010-05-17 17:34:19'),
(7,'sms_numero_mittente ',NULL,NULL,'3205747294','2010-04-28 02:22:31','2010-04-28 02:22:31'),
(8,'sms_provider_login ',NULL,NULL,'F05740','2010-04-28 02:22:43','2010-04-28 02:22:43'),
(9,'sms_provider_password',NULL,NULL,'487kp3q3','2010-04-28 02:22:56','2010-04-28 02:22:56'),
(10,'sms_testo_rapporto_pronto ',NULL,NULL,'Le prove richieste in data (RICHIESTA ANALISI xx/xx/xxxxx) sono pronte; i dati sono stati spediti via e-mail. Buon Lavoro\nhttp://centrobarbera.it ','2010-04-28 02:23:15','2010-04-28 11:33:00'),
(11,'email_mittente_per_notifiche ',NULL,NULL,'ceblab@tiscali.it','2010-04-28 02:23:31','2010-05-19 15:03:32'),
(12,'email_testo_rapporto_pronto',NULL,NULL,'Allego tabella riepilogatica relativa alle prove richieste.\nNel rimanere a vs completa disposizione,\nporgo i miei più cordiali saluti.\n\nDott. Francesco Massimiliano Barbera\n\n','2010-04-28 02:23:49','2010-05-19 09:55:18'),
(13,'email_oggetto_rapporto_pronto',NULL,NULL,'Analisi Pronte','2010-04-28 02:30:05','2010-04-28 02:30:05'),
(14,'email_cc_per_notifiche',NULL,'indirizzo su cui spedire copia di backup di tutte le mail in uscita','centrobarberabackup@gmail.com','2010-04-28 11:56:53','2010-05-19 15:03:01'),
(15,'rdp_stampa_sinal','Frase Sinal','Frase che compare nei certificati quando la tipologia è marchiata SINAL','Pareri ed interpretazioni - non oggetto dell''accreditamento SINAL.','2010-05-11 12:15:19','2010-05-11 12:15:19'),
(16,'email_testo_invio_rdp_e_anteprime',NULL,NULL,'Allego dati relativi alle prove richieste.\nNel rimanere a vs completa disposizione,\nporgo i miei più cordiali saluti.\n\nDott. Francesco Massimiliano Barbera','2010-05-19 12:50:55','2010-05-19 12:53:28'),
(17,'email_oggetto_invio_rdp_e_anteprime',NULL,NULL,'Invio Dati Analisi','2010-05-19 12:51:38','2010-05-19 12:51:38'),
(18,'anteprima_risultati_intestazione',NULL,NULL,'<img alt="" border="0" src="/images/rdp_intestazione.jpg" width = ''35%'' /></a>\n','2010-05-19 13:00:25','2010-05-19 13:07:09'),
(19,'anteprima_risultati_pie_pagina',NULL,NULL,'.','2010-05-19 13:00:40','2010-05-19 13:01:25'),
(20,'rdp_stampa_sinal_pie_pagina',NULL,'frase che compare in piè pagina (dopo la data)','(<sup><small>1</small></sup>) p=95% K=2 Estesa\n## = Prova non accreditata dal SINAL','2010-05-19 15:21:09','2010-05-19 17:41:25'),
(21,'rdp_stampa_firma',NULL,NULL,'<hr>\n<div style="  padding-left: 10cm; text-align: center;" >\nResponsabile del Laboratorio\nDott. F.sco Massimiliano Barbera\n</div>','2010-05-19 15:26:52','2010-05-19 18:09:58'),
(22,'rdp_stampa_pie_pagina_1',NULL,NULL,'<hr>\nIl rapporto di prova non può essere riprodotto parzialmente e riguarda solamente il campione sottoposto a prova','2010-05-19 15:32:25','2010-05-19 15:33:20');

--
-- Dumping data for table `prove`
--

INSERT INTO `prove` VALUES 
(8,3,'Acidità in Ac.Oleico','Acidità espressa in Acido Oleico','Reg 2568/91CEE 11/07/91All.II  GU L n.248 del 05/09/91',0,1600,NULL,'2010-02-12 19:03:08','2010-04-09 17:52:11'),
(9,3,'Numero di Perossidi','Numero di Perossidi','Reg 2568/91CEE 11/07/91All.III  GU L n.248 del 05/09/91',0,1500,NULL,'2010-02-12 19:10:37','2010-04-09 17:51:54'),
(10,3,'Analisi Spettrofotometrica nell\' U.V.','ANALISI SPETTROFOTOMETRICA NELL\' U.V.','Reg 2568/91CEE 11/07/91All. IX  GU L n.248 del 05/09/91',0,2000,NULL,'2010-02-12 19:12:50','2010-04-21 15:15:08'),
(11,3,'Polifenoli totali in Acido Gallico','## Polifenoli totali in Acido Gallico','Metodo Interno',0,1600,NULL,'2010-02-12 19:17:58','2010-04-21 15:17:13');

--
-- Dumping data for table `tipologie`
--

INSERT INTO `tipologie` VALUES 
(7,5,'Compravendita vino','Analisi compravendita vino',0,0,NULL,'2010-02-18 17:47:39','2010-05-19 15:35:38',1,'Rdp V-O Revisione n° 5 del 22/07/2008\n(*) GU L n.272 del 03/10/90 (**) GU n.161 del 14/07/86 (***) GU L n.248 del 05/09/91 (****) + Reg CE 128/04 GU CEE L 19 27/01/04 All 4bis'),
(8,5,'C.Q. vino','Analisi controllo qualità vino',0,0,NULL,'2010-02-18 17:49:35','2010-02-19 17:39:59',0,''),
(9,5,'Compr. Mosto Conc.','Analisi compravendita mosto concentrato',0,0,NULL,'2010-02-18 17:50:13','2010-05-19 15:56:04',1,'Rdp V-O Revisione n° 5 del 22/07/2008\n(*) GU L n.272 del 03/10/90 (**) GU n.161 del 14/07/86 (***) GU L n.248 del 05/09/91 (****) + Reg CE 128/04 GU CEE L 19 27/01/04 All 4bis'),
(10,5,'C.Q. mosto conc.','Analisi controllo qualità mosto concentrato',0,0,NULL,'2010-02-18 17:50:33','2010-02-19 17:38:46',0,''),
(11,5,'Compr. MCR','Analisi compravendita mosto concentrato rettificato',0,0,NULL,'2010-02-18 17:51:00','2010-05-19 15:55:45',1,'Rdp V-O Revisione n° 5 del 22/07/2008\n(*) GU L n.272 del 03/10/90 (**) GU n.161 del 14/07/86 (***) GU L n.248 del 05/09/91 (****) + Reg CE 128/04 GU CEE L 19 27/01/04 All 4bis');

--
-- Dumping data for table `variabili` 
-- Adattato alla struttura attuale del database
--

INSERT INTO `variabili` (id, matrice_id, udm_item_id, nome_esteso, nome, simbolo, funzione, tipo, min, max, decimali, valori_possibili, note, created_at, updated_at) VALUES 
(1,3,1,'Acidità espressa in acido oleico','Acidità espressa in acido oleico','H','(L*J*K*282)/(10*I)','funzione',0.1,2,2,NULL,NULL,'2010-02-12 11:29:32','2010-02-22 08:39:50'),
(2,3,1,'Grammi olio (pesati)','Grammi olio (pesati)','I',NULL,'input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:31:47','2010-02-12 11:35:57'),
(3,3,NULL,'Normalità Soluzione NaOH (0.1)','Normalità Soluzione NaOH','J','','input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:32:54','2010-04-30 10:02:17'),
(4,3,NULL,'FATTORE CORREZIONE NaOH (1.0)','FATTORE CORREZIONE NaOH','K','','input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:38:00','2010-04-30 10:02:00'),
(5,3,4,'ml di  NaOH  impiegati','ml di  NaOH  impiegati','L',NULL,'input-valore',NULL,NULL,2,NULL,NULL,'2010-02-12 11:38:56','2010-02-12 11:41:00');

-- Riabilita i controlli delle chiavi esterne
SET FOREIGN_KEY_CHECKS = 1;

-- Messaggio di conferma
SELECT 'Import completato con successo!' as Status;
