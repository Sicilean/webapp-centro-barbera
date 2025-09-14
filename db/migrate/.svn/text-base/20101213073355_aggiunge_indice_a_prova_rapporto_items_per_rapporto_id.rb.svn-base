class AggiungeIndiceAProvaRapportoItemsPerRapportoId < ActiveRecord::Migration
  def self.up
    add_index :prova_rapporto_items, :rapporto_id
  end

  def self.down
    remove_index :prova_rapporto_items,  :column => :rapporto_id
  end
end
