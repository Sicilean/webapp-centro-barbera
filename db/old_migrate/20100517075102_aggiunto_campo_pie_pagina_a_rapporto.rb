class AggiuntoCampoPiePaginaARapporto < ActiveRecord::Migration
  def self.up
    #add_column    :users,    :street,   :string,  :default => '',  :null => false
    add_column   :rapporti,  :pie_pagina, :text,  :default => '',  :null => false
  end

  def self.down
    #remove_column :users,    :street
    remove_column :rapporti, :pie_pagina
  end
end
