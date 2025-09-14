# Istruzioni per l'Esecuzione delle Correzioni

Questo documento fornisce istruzioni dettagliate per applicare le correzioni ai problemi identificati nell'applicazione Barbera.

## Prerequisiti

- Docker e Docker Compose installati e funzionanti
- L'applicazione Barbera avviata con `docker-compose up -d`
- Accesso alla shell del container dell'applicazione web

## 1. Backup del Database

Prima di effettuare qualsiasi modifica, è fondamentale eseguire un backup del database:

```bash
# Accedere al container del database
docker exec -it barberasoftware-db-1 bash

# Eseguire il backup
mysqldump -u root -ppassword barbera_development > /tmp/barbera_backup_$(date +%Y%m%d).sql

# Copiare il backup dal container alla macchina host
exit
docker cp barberasoftware-db-1:/tmp/barbera_backup_*.sql ./backups/
```

## 2. Accesso al Container dell'Applicazione

```bash
docker exec -it barberasoftware-web-1 bash
```

## 3. Creazione e Applicazione delle Migrazioni

### 3.1 Tabella `fatture`

```bash
cd /app
ruby script/generate migration CreateFatture
```

Modificare il file di migrazione creato (`db/migrate/XXXXXXXX_create_fatture.rb`) con il contenuto indicato nel file `script_correzione.md`.

### 3.2 Colonna `position` in `prova_tipologia_items`

```bash
cd /app
ruby script/generate migration AddPositionToProvaTipologiaItems
```

Modificare il file di migrazione creato (`db/migrate/XXXXXXXX_add_position_to_prova_tipologia_items.rb`) con il contenuto indicato nel file `script_correzione.md`.

### 3.3 Colonna `fattura_id` in `rapporti`

```bash
cd /app
ruby script/generate migration AddFatturaIdToRapporti
```

Modificare il file di migrazione creato (`db/migrate/XXXXXXXX_add_fattura_id_to_rapporti.rb`) con il contenuto indicato nel file `script_correzione.md`.

### 3.4 Applicazione delle Migrazioni

```bash
cd /app
rake db:migrate
```

## 4. Creazione e Modifica dei Modelli

### 4.1 Modello `Fattura`

Creare il file `app/models/fattura.rb` con il contenuto indicato nel file `script_correzione.md`.

### 4.2 Aggiornamento del Modello `Rapporto`

Modificare il file `app/models/rapporto.rb` per includere la relazione con `Fattura` come indicato nel file `script_correzione.md`.

## 5. Verifica delle Modifiche

### 5.1 Verifica delle Tabelle e Colonne

```bash
cd /app
ruby script/runner "puts ActiveRecord::Base.connection.tables.include?('fatture') ? 'Table fatture exists' : 'Table fatture does not exist'"
ruby script/runner "puts ActiveRecord::Base.connection.columns('prova_tipologia_items').map(&:name).include?('position') ? 'Column position exists' : 'Column position does not exist'"
ruby script/runner "puts ActiveRecord::Base.connection.columns('rapporti').map(&:name).include?('fattura_id') ? 'Column fattura_id exists' : 'Column fattura_id does not exist'"
```

### 5.2 Verifica del Funzionamento dell'Applicazione

Dopo aver applicato le modifiche, accedere all'applicazione tramite browser all'indirizzo `http://localhost:3000` e verificare che:

1. La sezione "Rapporti da completare" funzioni correttamente
2. La sezione "Clienti" funzioni correttamente
3. La sezione "Rapporti" funzioni correttamente
4. La sezione "Tipologie" funzioni correttamente
5. La sezione "Fatture" sia accessibile e funzionante
6. La sezione "Clienti in sospeso" funzioni correttamente

## 6. Procedura di Rollback in Caso di Problemi

Se si verificano problemi dopo l'applicazione delle modifiche, seguire questa procedura:

### 6.1 Identificare la Versione di Migrazione Precedente

```bash
cd /app
rake db:migrate:status
```

Identificare l'ultima migrazione prima delle modifiche applicate.

### 6.2 Eseguire il Rollback

```bash
cd /app
rake db:migrate VERSION=XXXX
```

Dove `XXXX` è il numero dell'ultima migrazione prima delle modifiche.

### 6.3 Ripristino del Backup

Se necessario, ripristinare il backup completo del database:

```bash
# Accedere al container del database
docker exec -it barberasoftware-db-1 bash

# Ripristinare il backup
mysql -u root -ppassword barbera_development < /tmp/barbera_backup_*.sql
```

## 7. Procedura di Test Completa

Per verificare approfonditamente che tutte le modifiche siano state applicate correttamente, eseguire questi test dalla console Rails:

```bash
cd /app
ruby script/console
```

### 7.1 Test della Tabella `fatture`

```ruby
# Creazione di una nuova fattura
cliente = Cliente.first
fattura = Fattura.new(
  :cliente_id => cliente.id,
  :numero => "F001/2025",
  :data => Date.today,
  :descrizione => "Test fattura",
  :importo => 100.50
)
fattura.save

# Verifica che la fattura sia stata salvata
Fattura.find_by_numero("F001/2025").nil? ? "Errore: Fattura non trovata" : "Fattura creata con successo"
```

### 7.2 Test della Colonna `position`

```ruby
# Verifica che la colonna position sia stata popolata
items = ProvaTipologiaItem.all(:order => "position ASC", :limit => 5)
items.each { |item| puts "ID: #{item.id}, Position: #{item.position}" }
```

### 7.3 Test della Relazione tra `Rapporto` e `Fattura`

```ruby
# Associazione di un rapporto a una fattura
rapporto = Rapporto.first
fattura = Fattura.first
rapporto.fattura = fattura
rapporto.save
rapporto.reload

# Verifica dell'associazione
rapporto.fattura_id == fattura.id ? "Relazione creata con successo" : "Errore: Relazione non creata"
```

## 8. Documentazione delle Modifiche

Dopo aver completato tutte le modifiche e verificato il loro funzionamento, aggiornare la documentazione del progetto:

1. Aggiungere una sezione nel README che descrive le modifiche apportate
2. Documentare la struttura della nuova tabella `fatture`
3. Aggiornare i diagrammi ER, se presenti
4. Annotare le modifiche nel registro delle versioni del progetto 