class AggiungiSinalATipologie < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column :tipologie, :sinal, :boolean
  end

  def self.down
    #remove_column :users,    :street
    remove_column :tipologie,   :sinal
  end
end

