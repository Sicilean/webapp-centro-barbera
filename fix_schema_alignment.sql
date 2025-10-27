-- Fix schema alignment con schema.rb

-- Verifica e aggiungi eventuali altre colonne mancanti (position è già stata aggiunta)
ALTER TABLE `prova_rapporto_items` MODIFY COLUMN `prezzo` FLOAT DEFAULT 0.0;

