class AggiungeIndiceAAutoProvaRapportoItemsPerRapportoId < ActiveRecord::Migration
  def self.up
    add_index :auto_prova_rapporto_items, :rapporto_id
  end

  def self.down
    remove_index :auto_prova_rapporto_items,  :column => :rapporto_id
  end
end
