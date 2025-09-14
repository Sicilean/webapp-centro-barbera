class AddMatriceIdToVariabili < ActiveRecord::Migration
  def self.up
    unless column_exists?(:variabili, :matrice_id)
      add_column :variabili, :matrice_id, :integer
      add_index :variabili, [:matrice_id, :simbolo], name: 'index_variabili_on_matrice_id_and_simbolo'
    end
  end

  def self.down
    if column_exists?(:variabili, :matrice_id)
      remove_index :variabili, name: 'index_variabili_on_matrice_id_and_simbolo'
      remove_column :variabili, :matrice_id
    end
  end
end 