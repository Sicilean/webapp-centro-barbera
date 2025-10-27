# Importazione Dati Barbera Software

Questo documento descrive come vengono importati i dati nel database Barbera Software durante il build Docker.

## File di Importazione

I dati vengono importati tramite i seguenti file SQL, in ordine sequenziale:

1. **`import_chunk_01_setup.sql`** - Setup e pulizia database
   - Disabilita i controlli delle chiavi esterne
   - Svuota le tabelle esistenti
   - Reset degli auto_increment

2. **`import_chunk_02_matrici_parametri.sql`** - Matrici e Parametri
   - Inserisce le matrici (Olio, Suolo, Enologia, Concime, Terreno)
   - Inserisce i parametri di configurazione

3. **`import_chunk_03_clienti_parte1.sql`** - Clienti parte 1 (primi 20)
   - Inserisce i primi 20 clienti del database

4. **`import_chunk_04_clienti_parte2.sql`** - Clienti parte 2 (dal 23 al 50)
   - Inserisce i clienti dal 23 al 50

5. **`import_chunk_05_clienti_parte3.sql`** - Clienti parte 3 (dal 50 al 101)
   - Inserisce i clienti dal 50 al 101

6. **`import_chunk_06_prove_complete.sql`** - Tutte le prove
   - Inserisce tutte le prove disponibili per le diverse matrici

7. **`import_chunk_07_tipologie_complete.sql`** - Tutte le tipologie
   - Inserisce tutte le tipologie di analisi

8. **`import_chunk_08_variabili_sample.sql`** - Campione di variabili
   - Inserisce un campione delle prime 10 variabili più importanti

## Processo di Importazione

### Durante il Build Docker

1. I file SQL vengono copiati nel container durante il build
2. Lo script `import_data.sh` viene reso eseguibile
3. L'entrypoint del container esegue automaticamente l'importazione

### Esecuzione Automatica

L'importazione avviene automaticamente quando:
- Il container viene avviato per la prima volta
- Il database è vuoto (nessun cliente presente)
- MySQL è disponibile e connesso

### Esecuzione Manuale

Per eseguire manualmente l'importazione:

```bash
# All'interno del container
/app/import_data.sh

# Oppure eseguire i singoli chunk
mysql -h 172.19.0.2 -u root -ppassword barbera_development < /app/import_chunk_01_setup.sql
```

## Configurazione

### Variabili d'Ambiente

- `RAILS_ENV`: Ambiente Rails (default: development)
- Il database viene creato come `barbera_${RAILS_ENV}`

### Connessione MySQL

- Host: 172.19.0.2
- Porta: 3306
- Username: root
- Password: password

## Verifica Importazione

Dopo l'importazione, puoi verificare che i dati siano stati caricati:

```sql
-- Conta i clienti
SELECT COUNT(*) FROM clienti;

-- Conta le prove
SELECT COUNT(*) FROM prove;

-- Conta le tipologie
SELECT COUNT(*) FROM tipologie;

-- Conta le variabili
SELECT COUNT(*) FROM variabili;
```

## Troubleshooting

### Problemi Comuni

1. **Errore di connessione MySQL**: Verifica che il container MySQL sia in esecuzione
2. **Database già popolato**: L'importazione viene saltata se il database contiene già dati
3. **Errori di sintassi SQL**: Verifica che i file SQL siano validi

### Log di Debug

I log dell'importazione sono visibili nei log del container:

```bash
docker logs <container_name>
```

## Note Tecniche

- L'importazione è idempotente: può essere eseguita più volte senza duplicare i dati
- I controlli delle chiavi esterne vengono disabilitati durante l'importazione
- Gli auto_increment vengono resettati per mantenere la consistenza degli ID
