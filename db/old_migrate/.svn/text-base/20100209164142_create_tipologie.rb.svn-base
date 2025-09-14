class CreateTipologie < ActiveRecord::Migration
  def self.up
    create_table(:tipologie, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :matrice_id
      t.string :nome
      t.string :nome_esteso
      t.boolean :forfeit
      t.float  :prezzo, :default => 0 # TIENILO FLOAT altimenti active scaff fa casino;  we store the prince in cents! Vedi Agile p. 90
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :tipologie
  end
end
