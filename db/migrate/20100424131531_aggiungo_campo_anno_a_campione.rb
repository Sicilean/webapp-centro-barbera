class AggiungoCampoAnnoACampione < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column   :campioni,  :anno, :integer, :default => nil
  end

  def self.down
    #remove_column :users,    :street
    remove_column :campioni, :anno
  end
end
