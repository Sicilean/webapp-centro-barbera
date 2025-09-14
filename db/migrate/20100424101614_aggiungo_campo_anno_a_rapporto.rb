class AggiungoCampoAnnoARapporto < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column   :rapporti,  :anno, :integer, :default => nil 
  end

  def self.down
    #remove_column :users,    :street
    remove_column :rapporti, :anno
  end
end
