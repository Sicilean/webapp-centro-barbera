-- Crea le tabelle mancanti dal schema.rb

CREATE TABLE IF NOT EXISTS `fatture` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) DEFAULT NULL,
  `numero` int(11) DEFAULT NULL,
  `anno` int(11) DEFAULT NULL,
  `data_emissione` date DEFAULT NULL,
  `percentuale_sconto` float DEFAULT 0.0,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `data_pagamento` date DEFAULT NULL,
  `totale_in_pdf` float DEFAULT NULL,
  `pdf_esiste` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `note` text,
  `usa_indirizzo_di_fatturazione` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `fattura_rapporto_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fattura_id` int(11) DEFAULT NULL,
  `rapporto_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `auto_prova_rapporto_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `prova_id` int(11) DEFAULT NULL,
  `rapporto_id` int(11) DEFAULT NULL,
  `prezzo` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_auto_prova_rapporto_items_on_rapporto_id` (`rapporto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

