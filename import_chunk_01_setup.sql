-- CHUNK 1: Setup e pulizia database
-- Importazione completa dati Barbera Software

USE barbera_development;

-- Disabilita i controlli delle chiavi esterne temporaneamente
SET FOREIGN_KEY_CHECKS = 0;

-- Svuota le tabelle esistenti (solo i dati, non la struttura)
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

SELECT 'Chunk 1: Setup completato!' as Status;
