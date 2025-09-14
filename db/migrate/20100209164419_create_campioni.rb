class CreateCampioni < ActiveRecord::Migration
  def self.up
    create_table(:campioni, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :cliente_id
      t.string :campione_di
      t.text :etichetta
      t.string :nome_richiedente
      t.integer :numero
      t.date   :data
      t.string :campionamento
      t.string :non_conforme_motivo
      # vino
      t.string :suggello
      # suolo
      t.string :comune
      t.string :provincia
      t.string :località
      t.string :tipo_di_coltura
      t.string :fase_coltura
      t.string :ettari
      t.string :superficie_di_prelievo
      t.string :profondita_di_prelievo
      t.string :numero_foglio_di_mappa
      t.string :particelle
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :campioni
  end
end
