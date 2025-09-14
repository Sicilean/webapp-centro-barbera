class AddSimboloToVariabili < ActiveRecord::Migration
  def self.up
    unless column_exists?(:variabili, :simbolo)
      add_column :variabili, :simbolo, :string
    end
  end

  def self.down
    if column_exists?(:variabili, :simbolo)
      remove_column :variabili, :simbolo
    end
  end
end 