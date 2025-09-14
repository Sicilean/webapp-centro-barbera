class ModificaTipoEtichetta < ActiveRecord::Migration
  def self.up
    remove_column :campioni,   :etichetta
    add_column    :campioni,   :etichetta, :text
  end

  def self.down
    remove_column :campioni,   :etichetta
    add_column    :campioni,   :etichetta, :string
  end
end
