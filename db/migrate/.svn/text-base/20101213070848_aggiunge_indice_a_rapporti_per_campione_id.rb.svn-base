class AggiungeIndiceARapportiPerCampioneId < ActiveRecord::Migration
  def self.up
    add_index :rapporti, :campione_id
  end

  def self.down
    remove_index :rapporti,  :column => :campione_id
  end
end
