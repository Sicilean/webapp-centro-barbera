class EliminaTabellaCampioneTipologiaItems < ActiveRecord::Migration
  def self.up
    drop_table  :campione_tipologia_items
  end

  def self.down
  end
end
