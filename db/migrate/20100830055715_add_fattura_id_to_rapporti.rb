class AddFatturaIdToRapporti < ActiveRecord::Migration
  def self.up
    add_column   :rapporti, :fattura_id, :integer
  end

  def self.down
    remove_column :rapporti, :fattura_id
  end
end
