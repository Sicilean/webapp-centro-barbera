class AggiungiCellulare2ACliente < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column :clienti, :cellulare_per_sms_2, :string
    add_column :clienti, :titolare_cellulare_2, :string
  end

  def self.down
    #remove_column :users,    :street
    remove_column :clienti,   :cellulare_per_sms_2
    remove_column :clienti,   :titolare_cellulare_2
  end
end
