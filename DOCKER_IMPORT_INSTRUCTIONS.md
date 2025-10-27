# Istruzioni per l'Importazione Dati con Docker

## Panoramica

I file SQL di importazione sono ora integrati nel processo di build Docker. Quando costruisci e avvii il container, i dati vengono automaticamente importati nel database.

## File Inclusi

I seguenti file sono ora inclusi nel build Docker:

- `import_chunk_01_setup.sql` - Setup e pulizia database
- `import_chunk_02_matrici_parametri.sql` - Matrici e parametri
- `import_chunk_03_clienti_parte1.sql` - Clienti parte 1 (primi 20)
- `import_chunk_04_clienti_parte2.sql` - Clienti parte 2 (dal 23 al 50)
- `import_chunk_05_clienti_parte3.sql` - Clienti parte 3 (dal 50 al 101)
- `import_chunk_06_prove_complete.sql` - Tutte le prove
- `import_chunk_07_tipologie_complete.sql` - Tutte le tipologie
- `import_chunk_08_variabili_sample.sql` - Campione di variabili
- `import_data.sh` - Script di importazione automatica
- `test_import.sh` - Script di test per l'importazione

## Come Utilizzare

### 1. Build del Container

```bash
# Naviga nella directory del progetto
cd webapp-centro-barbera

# Costruisci l'immagine Docker
docker build -t barbera-software .
```

### 2. Avvio con Docker Compose

```bash
# Avvia tutti i servizi (web + database)
docker-compose up -d

# Visualizza i log per monitorare l'importazione
docker-compose logs -f web
```

### 3. Verifica dell'Importazione

```bash
# Accedi al container web
docker-compose exec web bash

# Esegui lo script di test
/app/test_import.sh

# Oppure verifica manualmente
mysql -h 172.19.0.2 -u root -ppassword -e "SELECT COUNT(*) FROM barbera_development.clienti;"
```

### 4. Importazione Manuale

Se hai bisogno di eseguire l'importazione manualmente:

```bash
# Accedi al container
docker-compose exec web bash

# Esegui lo script di importazione
/app/import_data.sh
```

## Processo Automatico

### Durante l'Avvio del Container

1. **Connessione MySQL**: Il container attende che MySQL sia disponibile
2. **Creazione Database**: Crea il database se non esiste
3. **Caricamento Schema**: Carica lo schema del database se necessario
4. **Importazione Dati**: Esegue automaticamente tutti i chunk di importazione
5. **Avvio Applicazione**: Avvia il server Rails

### Controlli di Sicurezza

- L'importazione viene eseguita solo se il database è vuoto
- I controlli delle chiavi esterne vengono disabilitati durante l'importazione
- Gli auto_increment vengono resettati per mantenere la consistenza

## Configurazione

### Variabili d'Ambiente

- `RAILS_ENV`: Ambiente Rails (default: development)
- Il database viene creato come `barbera_${RAILS_ENV}`

### Connessione Database

- Host: 172.19.0.2
- Porta: 3306
- Username: root
- Password: password

## Troubleshooting

### Problemi Comuni

1. **Container non si avvia**: Verifica che MySQL sia in esecuzione
2. **Errore di importazione**: Controlla i log del container
3. **Database già popolato**: L'importazione viene saltata automaticamente

### Log di Debug

```bash
# Visualizza tutti i log
docker-compose logs

# Visualizza solo i log del web
docker-compose logs web

# Segui i log in tempo reale
docker-compose logs -f web
```

### Reset Completo

Se hai bisogno di ricominciare da capo:

```bash
# Ferma tutti i container
docker-compose down

# Rimuovi i volumi (ATTENZIONE: cancella tutti i dati)
docker-compose down -v

# Ricostruisci e riavvia
docker-compose up --build -d
```

## File di Supporto

- `IMPORT_DATA_README.md`: Documentazione dettagliata sui file di importazione
- `import_data.sh`: Script principale di importazione
- `test_import.sh`: Script di test per verificare l'importazione
- `Dockerfile`: Configurazione Docker aggiornata
- `docker-compose.yml`: Configurazione Docker Compose aggiornata

## Note Importanti

- I file SQL vengono copiati nel container durante il build
- L'importazione è idempotente: può essere eseguita più volte senza problemi
- I dati vengono importati solo se il database è vuoto
- Il processo è completamente automatico durante l'avvio del container
