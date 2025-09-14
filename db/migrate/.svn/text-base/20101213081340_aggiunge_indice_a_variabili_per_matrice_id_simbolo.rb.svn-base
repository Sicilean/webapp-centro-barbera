class AggiungeIndiceAVariabiliPerMatriceIdSimbolo < ActiveRecord::Migration
  def self.up
    add_index :variabili, [:matrice_id, :simbolo ]
  end

  def self.down
    remove_index :variabili,  :column => [:matrice_id, :simbolo ]
  end
end
