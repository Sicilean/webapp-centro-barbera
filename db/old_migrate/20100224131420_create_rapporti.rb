class CreateRapporti < ActiveRecord::Migration
  def self.up
    create_table(:rapporti, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|

      t.integer :tipologia_id
      t.integer :campione_id
      t.integer :numero
      t.integer :numero_supplemento
      t.string :status
      t.date :data_richiesta
      t.datetime :data_scadenza
      t.datetime :data_invio_email
      t.datetime :data_invio_sms
      t.date :data_esecuzione_prove
      t.date :data_stampa
      t.float :prezzo, :default => 0
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :rapporti
  end
end
