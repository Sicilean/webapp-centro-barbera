# Script per Correzione Problemi dell'Applicazione Barbera

Questo documento contiene gli script e le migrazioni necessari per risolvere i problemi individuati.

## 1. Creazione della Tabella `fatture`

### 1.1 Migrazione per Creare la Tabella `fatture`

Creare un nuovo file di migrazione con il comando:

```bash
cd /app
ruby script/generate migration CreateFatture
```

Modificare il file di migrazione creato (in `db/migrate/XXXXXXXX_create_fatture.rb`) con il seguente contenuto:

```ruby
class CreateFatture < ActiveRecord::Migration
  def self.up
    create_table :fatture do |t|
      t.integer :cliente_id
      t.string :numero
      t.date :data
      t.text :descrizione
      t.decimal :importo, :precision => 10, :scale => 2
      t.boolean :pagata, :default => false
      t.date :data_pagamento
      t.string :metodo_pagamento
      t.text :note
      t.timestamps
    end
    
    add_index :fatture, :cliente_id
    add_index :fatture, :numero
    add_index :fatture, :data
  end

  def self.down
    drop_table :fatture
  end
end
```

### 1.2 Modello `Fattura`

Creare il file `app/models/fattura.rb` con il seguente contenuto:

```ruby
class Fattura < ActiveRecord::Base
  belongs_to :cliente
  has_many :rapporti
  
  validates_presence_of :cliente_id, :numero, :data, :importo
  validates_uniqueness_of :numero
  
  def self.totale_per_cliente(cliente_id)
    sum(:importo, :conditions => { :cliente_id => cliente_id })
  end
  
  def self.non_pagate
    find(:all, :conditions => { :pagata => false })
  end
end
```

## 2. Aggiunta della Colonna `position` a `prova_tipologia_items`

### 2.1 Migrazione per Aggiungere la Colonna `position`

Creare un nuovo file di migrazione con il comando:

```bash
cd /app
ruby script/generate migration AddPositionToProvaTipologiaItems
```

Modificare il file di migrazione creato (in `db/migrate/XXXXXXXX_add_position_to_prova_tipologia_items.rb`) con il seguente contenuto:

```ruby
class AddPositionToProvaTipologiaItems < ActiveRecord::Migration
  def self.up
    add_column :prova_tipologia_items, :position, :integer, :default => 0
    
    # Aggiorna la posizione degli elementi esistenti
    execute "UPDATE prova_tipologia_items SET position = id"
  end

  def self.down
    remove_column :prova_tipologia_items, :position
  end
end
```

## 3. Aggiunta della Colonna `fattura_id` a `rapporti`

### 3.1 Migrazione per Aggiungere la Colonna `fattura_id`

Creare un nuovo file di migrazione con il comando:

```bash
cd /app
ruby script/generate migration AddFatturaIdToRapporti
```

Modificare il file di migrazione creato (in `db/migrate/XXXXXXXX_add_fattura_id_to_rapporti.rb`) con il seguente contenuto:

```ruby
class AddFatturaIdToRapporti < ActiveRecord::Migration
  def self.up
    add_column :rapporti, :fattura_id, :integer
    add_index :rapporti, :fattura_id
  end

  def self.down
    remove_column :rapporti, :fattura_id
  end
end
```

### 3.2 Aggiornamento del Modello `Rapporto`

Aggiornare il file `app/models/rapporto.rb` per aggiungere la relazione con `Fattura`:

```ruby
class Rapporto < ActiveRecord::Base
  belongs_to :cliente
  belongs_to :fattura
  
  # Mantenere le altre relazioni e validazioni esistenti
  
  # Aggiungere un metodo per trovare i rapporti senza fattura
  def self.senza_fattura
    find(:all, :conditions => "fattura_id IS NULL")
  end
end
```

## 4. Applicazione delle Migrazioni

Eseguire le migrazioni con il comando:

```bash
cd /app
rake db:migrate
```

## 5. Script per Test delle Migrazioni

Per testare che le migrazioni siano state applicate correttamente:

```bash
cd /app
ruby script/runner "puts ActiveRecord::Base.connection.tables.include?('fatture') ? 'Table fatture exists' : 'Table fatture does not exist'"
ruby script/runner "puts ActiveRecord::Base.connection.columns('prova_tipologia_items').map(&:name).include?('position') ? 'Column position exists' : 'Column position does not exist'"
ruby script/runner "puts ActiveRecord::Base.connection.columns('rapporti').map(&:name).include?('fattura_id') ? 'Column fattura_id exists' : 'Column fattura_id does not exist'"
```

## 6. Istruzioni per il Test delle Funzionalità

1. **Test della Tabella `fatture`**:
   ```bash
   cd /app
   ruby script/console
   > fattura = Fattura.new(:cliente_id => Cliente.first.id, :numero => "F001", :data => Date.today, :importo => 100.0)
   > fattura.save
   > Fattura.count
   ```

2. **Test dell'Ordinamento con `position`**:
   ```bash
   cd /app
   ruby script/console
   > ProvaTipologiaItem.all(:order => "position ASC").map(&:position)
   ```

3. **Test della Relazione tra `Rapporto` e `Fattura`**:
   ```bash
   cd /app
   ruby script/console
   > rapporto = Rapporto.first
   > fattura = Fattura.first
   > rapporto.fattura = fattura
   > rapporto.save
   > rapporto.reload.fattura_id == fattura.id
   ```

## 7. Rollback in caso di Problemi

Per ripristinare il database allo stato precedente:

```bash
cd /app
rake db:migrate VERSION=XXXX
```

Dove `XXXX` è il numero della migrazione precedente all'applicazione delle modifiche. 