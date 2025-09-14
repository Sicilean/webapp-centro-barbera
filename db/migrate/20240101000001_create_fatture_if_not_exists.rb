class CreateFattureIfNotExists < ActiveRecord::Migration
  def self.up
    begin
      tables = ActiveRecord::Base.connection.tables
      
      unless tables.include?('fatture')
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
    rescue Exception => e
      puts "Error creating fatture table: #{e.message}"
    end
  end

  def self.down
    begin
      tables = ActiveRecord::Base.connection.tables
      
      if tables.include?('fatture')
        drop_table :fatture
      end
    rescue Exception => e
      puts "Error dropping fatture table: #{e.message}"
    end
  end
end 