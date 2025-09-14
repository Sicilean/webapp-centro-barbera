class AggiungoCampoValoreForzatoAVariabili < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column   :variabile_rapporto_items,  :valore_numero_forzato, :decimal, :precision => 25, :scale => 11,  :default => nil # ho bisogno del nil, per capire se 0 è un valore!
  end

  def self.down
    #remove_column :users,    :street
    remove_column :variabile_rapporto_items, :valore_numero_forzato
  end
end
