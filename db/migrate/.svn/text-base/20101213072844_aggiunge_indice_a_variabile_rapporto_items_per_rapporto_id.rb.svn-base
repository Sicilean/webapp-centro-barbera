class AggiungeIndiceAVariabileRapportoItemsPerRapportoId < ActiveRecord::Migration
  def self.up
    add_index :variabile_rapporto_items, :rapporto_id
  end

  def self.down
    remove_index :variabile_rapporto_items,  :column => :rapporto_id
  end
end
