class CreateRisultati < ActiveRecord::Migration
  def self.up
    create_table(:risultati, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :variabile_id
      t.integer :campione_id
      t.integer :data
      t.decimal :valore_numero, :precision => 25, :scale => 11
      t.string :valore_testo
      t.string :incertezza_di_misura

      t.timestamps
    end
  end

  def self.down
    drop_table :risultati
  end
end
