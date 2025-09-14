class CreateFatture < ActiveRecord::Migration
  def self.up
    create_table(:fatture, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|
      t.integer :cliente_id
      t.integer :numero
      t.integer :anno
      t.date :data_emissione
      t.float :percentuale_sconto, :default => 0
      t.date :data_inizio
      t.date :data_fine
      t.date :data_pagamento
      t.float :totale_in_pdf
      t.boolean :pdf_esiste # diventa true al momento della creazione del pdf
      t.timestamps
    end
  end

  def self.down
    drop_table :fatture
  end
end
