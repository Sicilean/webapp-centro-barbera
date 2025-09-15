-- Script per inserire i parametri essenziali per la generazione PDF
-- Esegui con: docker-compose exec db mysql -u root -ppassword barbera_development < fix_parametri.sql

USE barbera_development;

-- Parametri per anteprima risultati
INSERT IGNORE INTO parametri (codice, nome, valore, created_at, updated_at) VALUES 
('anteprima_risultati_intestazione', 'Intestazione Anteprima Risultati', '<div style="text-align: center;"><img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" /><br/><h2>ANTEPRIMA RISULTATI ANALISI</h2></div>', NOW(), NOW()),

('anteprima_risultati_pie_pagina', 'Piè di pagina Anteprima', '<hr style="margin-top: 20px;"><p style="font-size: 10px; text-align: center;">Centro di Analisi Barbera - Laboratorio di Analisi Chimiche<br/>Via Esempio, 123 - 91100 Trapani (TP)<br/>Tel: 0923-123456 - Email: info@centrobarbera.it</p>', NOW(), NOW()),

-- Parametri per RDP
('rdp_stampa_intestazione', 'Intestazione RDP Standard', '<img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" />', NOW(), NOW()),

('rdp_stampa_intestazione_con_sinal', 'Intestazione RDP con SINAL', '<img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" /><p style="text-align: center; font-weight: bold;">Laboratorio accreditato SINAL n° 0123</p>', NOW(), NOW()),

('lab_comune', 'Località Laboratorio', 'Trapani', NOW(), NOW()),

('rdp_stampa_firma', 'Sezione Firma RDP', '<div style="padding-left: 10cm; text-align: center;">> Responsabile del Laboratorio Dott. F.sco Massimiliano Barbera <<br/>___________________________</div>', NOW(), NOW()),

('rdp_stampa_pie_pagina_1', 'Prima riga piè di pagina RDP', '<hr style="margin-top: 10px;"><p style="font-size: 9px;">Il rapporto di prova non può essere riprodotto parzialmente e riguarda solamente il campione sottoposto a prova</p>', NOW(), NOW()),

('rdp_stampa_pie_pagina_3', 'Ultima riga piè di pagina RDP', 'Autorizzazione MIPAF al rilascio dei certificati validi ai fini della commercializzazione ed esportazione dei vini (prot. 60662 del 13/03/1996)', NOW(), NOW()),

('rdp_stampa_sinal', 'Note SINAL per RDP', '<p style="font-size: 9px;"><sup>(1)</sup> Pareri ed interpretazioni - non oggetto dell\'accreditamento SINAL.</p>', NOW(), NOW()),

('rdp_stampa_sinal_pie_pagina', 'Piè di pagina SINAL', 'Frase che compare in piè di pagina quando la tipologia è marcata SINAL', NOW(), NOW()),

('rdp_stampa_frase_per_supplemento', 'Frase per supplementi', 'Il presente supplemento annulla e sostituisce il rapporto di prova a cui fa riferimento', NOW(), NOW()),

-- Parametri aggiuntivi
('dati_stampa_intestazione', 'Intestazione stampa dati', '<img alt="" border="0" src="/images/rdp_intestazione.jpg" width="35%" />', NOW(), NOW()),

('dati_stampa_titolo', 'Titolo anteprima analisi', 'Anteprima Rapporto di Prova', NOW(), NOW());

-- Verifica inserimento
SELECT CONCAT('✅ Inseriti ', COUNT(*), ' parametri per la generazione PDF') as Risultato 
FROM parametri 
WHERE codice IN ('anteprima_risultati_intestazione', 'rdp_stampa_intestazione', 'lab_comune', 'rdp_stampa_firma', 'rdp_stampa_pie_pagina_1');
