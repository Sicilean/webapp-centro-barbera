class CreateVariabili < ActiveRecord::Migration
  def self.up
    create_table(:variabili, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :matrice_id
      t.integer :udm_item_id
      t.string :nome
      t.string :nome_esteso
      t.string :simbolo
      t.string :funzione
      t.string :tipo
      t.float :min
      t.float :max
      t.integer :decimali
      t.boolean :forza_zero
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :variabili
  end
end
