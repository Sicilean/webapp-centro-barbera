class EliminaCampoDataDaVariabileRapportoItem < ActiveRecord::Migration
  def self.up
    #remove_column :variabile_rapporto_items,   :data
    rename_column :variabile_rapporto_items,   :data, :vecchio_campo_data_buttami
  end

  def self.down
  end
end
