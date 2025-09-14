class EliminaTabellaCampioneProvaItems < ActiveRecord::Migration
  def self.up
    drop_table  :campione_prova_items
  end

  def self.down
  end
end
