class CreateVariabileRapportoItems < ActiveRecord::Migration
  def self.up
    create_table(:variabile_rapporto_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|
      t.integer :variabile_id
      t.integer :rapporto_id
      t.date :data
      t.decimal :valore_numero, :precision => 25, :scale => 11,     :default => nil # ho bisogno del nil, per capire se 0 è un valore!
      t.string :valore_testo
      t.string :incertezza_di_misura
      t.string :errore,  :default => nil # campo che contiene l'eventuale errore della formula eval (es. divisione per zero)

      t.timestamps
    end
  end

  def self.down
    drop_table :variabile_rapporto_items
  end
end
