class AggiungeIndiceARapportiPerFatturaId < ActiveRecord::Migration
  def self.up
    add_index :rapporti, :fattura_id
  end

  def self.down
    remove_index :rapporti,  :column => :fattura_id
  end
end
