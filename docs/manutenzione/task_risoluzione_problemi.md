# Task per la Risoluzione dei Problemi dell'Applicazione Barbera

## Problemi Identificati

Dall'analisi degli errori, emergono i seguenti problemi:

1. **Tabella `fatture` mancante**:
   - Causa errori in: Rapporti da completare, Clienti, Rapporti, Fatture
   - Errore: `Mysql::Error: Table 'barbera_development.fatture' doesn't exist`

2. **Colonna `position` mancante in `prova_tipologia_items`**:
   - Causa errori nella sezione Tipologie
   - Errore: `Mysql::Error: Unknown column 'position' in 'order clause'`

3. **Colonna `fattura_id` mancante in `rapporti`**:
   - Causa errori in Clienti in sospeso
   - Errore: `Mysql::Error: Unknown column 'fattura_id' in 'where clause'`

## Task da Completare

### 1. Analisi dello Schema del Database

- [x] Esaminare lo schema attuale del database
- [x] Verificare le migrazioni esistenti
- [x] Analizzare i modelli coinvolti e le loro relazioni

### 2. Creazione della Tabella `fatture`

- [x] Definire la struttura della tabella `fatture`
- [x] Creare una migrazione per la tabella `fatture`
- [x] Applicare la migrazione
- [x] Verificare che la tabella sia stata creata correttamente

### 3. Aggiunta della Colonna `position` a `prova_tipologia_items`

- [x] Creare una migrazione per aggiungere la colonna `position` a `prova_tipologia_items`
- [x] Applicare la migrazione
- [x] Aggiornare i dati esistenti per popolare la colonna `position`

### 4. Aggiunta della Colonna `fattura_id` a `rapporti`

- [x] Creare una migrazione per aggiungere la colonna `fattura_id` a `rapporti`
- [x] Applicare la migrazione
- [x] Aggiornare i modelli per riflettere la relazione tra `rapporti` e `fatture`

### 5. Verificare il Modello `Fattura`

- [x] Creare o aggiornare il modello `Fattura`
- [x] Definire le relazioni con altri modelli (es. `Rapporto`, `Cliente`)
- [x] Implementare le validazioni necessarie

### 6. Testing delle Modifiche

- [x] Testare la sezione Rapporti da completare
- [x] Testare la sezione Clienti
- [x] Testare la sezione Rapporti
- [x] Testare la sezione Tipologie
- [x] Testare la sezione Fatture
- [x] Testare la sezione Clienti in sospeso

## Regole per lo Sviluppo

1. **Mantenere la Compatibilità**:
   - Le modifiche devono essere compatibili con Ruby 1.8.7 e Rails 2.3.8
   - Non utilizzare sintassi Ruby o Rails moderne che potrebbero non essere supportate

2. **Gestione delle Migrazioni**:
   - Ogni cambiamento al database deve essere fatto tramite migrazioni
   - Le migrazioni devono essere reversibili (includere `up` e `down`)
   - Testare sia l'applicazione che la rimozione di ogni migrazione

3. **Naming Convention**:
   - Seguire le convenzioni di naming di Rails 2.3.8
   - Utilizzare nomi di tabelle plurali e modelli singolari
   - Mantenere coerenza con le convenzioni esistenti nel progetto

4. **Backup e Rollback**:
   - Prima di ogni modifica, fare un backup del database
   - Avere un piano di rollback per ogni modifica
   - Testare il rollback prima di applicare le modifiche in produzione

5. **Testing Incrementale**:
   - Testare ogni modifica singolarmente prima di passare alla successiva
   - Verificare che ogni sezione dell'applicazione funzioni dopo ogni modifica
   - Documentare i test eseguiti e i risultati ottenuti

6. **Documentazione**:
   - Documentare tutte le modifiche apportate
   - Aggiornare la documentazione esistente se necessario
   - Commentare il codice per spiegare le modifiche non ovvie

7. **Gestione delle Dipendenze**:
   - Verificare che tutte le gemme necessarie siano disponibili
   - Non aggiungere dipendenze che potrebbero causare incompatibilità

8. **Sicurezza**:
   - Implementare adeguate validazioni nei modelli
   - Verificare la sicurezza delle operazioni di manipolazione dati
   - Assicurarsi che le modifiche non introducano vulnerabilità di sicurezza

## Procedure di Testing

### Test della Tabella `fatture`

1. Verificare la creazione della tabella con `SHOW TABLES LIKE 'fatture'`
2. Inserire alcuni record di test
3. Verificare che i record possano essere recuperati correttamente
4. Testare le relazioni con altre tabelle

### Test della Colonna `position`

1. Verificare l'aggiunta della colonna con `SHOW COLUMNS FROM prova_tipologia_items LIKE 'position'`
2. Verificare che la colonna contenga valori validi
3. Testare l'ordinamento utilizzando la colonna `position`

### Test della Colonna `fattura_id`

1. Verificare l'aggiunta della colonna con `SHOW COLUMNS FROM rapporti LIKE 'fattura_id'`
2. Verificare che la colonna possa essere popolata correttamente
3. Testare le query che utilizzano la colonna `fattura_id`

## Timeline di Implementazione

1. **Giorno 1**: Analisi e pianificazione
   - Completare l'analisi del database
   - Definire la struttura delle nuove tabelle/colonne
   - Creare le migrazioni necessarie

2. **Giorno 2**: Implementazione delle migrazioni
   - Applicare le migrazioni
   - Verificare che le tabelle/colonne siano state create correttamente
   - Iniziare l'aggiornamento dei modelli

3. **Giorno 3**: Implementazione dei modelli e testing
   - Completare l'aggiornamento dei modelli
   - Eseguire i test per ogni sezione dell'applicazione
   - Documentare i risultati

4. **Giorno 4**: Completamento e documentazione
   - Risolvere eventuali problemi emersi durante i test
   - Finalizzare la documentazione
   - Preparare il deployment in produzione 