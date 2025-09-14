class AggiungePostitionAProvaTipologiaItem < ActiveRecord::Migration
  def self.up
    # The precision represents the number of significant digits that are
    # stored for values, and the scale represents the number of digits that
    # can be stored following the decimal point. If the scale is 0, DECIMAL and NUMERIC
    # values contain no decimal point or fractional part.
    add_column   :prova_tipologia_items,  :position, :decimal, :precision => 15
  end

  def self.down
    remove_column :prova_tipologia_items, :position
  end
end
