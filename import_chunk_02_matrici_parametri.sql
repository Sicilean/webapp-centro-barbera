-- CHUNK 2: Matrici e Parametri
USE barbera_development;

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

SELECT 'Chunk 2: Matrici e Parametri completati!' as Status;
