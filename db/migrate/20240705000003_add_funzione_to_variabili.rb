class AddFunzioneToVariabili < ActiveRecord::Migration
  def self.up
    unless column_exists?(:variabili, :funzione)
      add_column :variabili, :funzione, :string
    end
  end

  def self.down
    if column_exists?(:variabili, :funzione)
      remove_column :variabili, :funzione
    end
  end
end 