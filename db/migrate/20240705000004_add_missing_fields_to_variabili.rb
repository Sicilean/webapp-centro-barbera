class AddMissingFieldsToVariabili < ActiveRecord::Migration
  def self.up
    unless column_exists?(:variabili, :nome_esteso)
      add_column :variabili, :nome_esteso, :string
    end
    unless column_exists?(:variabili, :min)
      add_column :variabili, :min, :float
    end
    unless column_exists?(:variabili, :max)
      add_column :variabili, :max, :float
    end
    unless column_exists?(:variabili, :forza_zero)
      add_column :variabili, :forza_zero, :boolean
    end
  end

  def self.down
    if column_exists?(:variabili, :nome_esteso)
      remove_column :variabili, :nome_esteso
    end
    if column_exists?(:variabili, :min)
      remove_column :variabili, :min
    end
    if column_exists?(:variabili, :max)
      remove_column :variabili, :max
    end
    if column_exists?(:variabili, :forza_zero)
      remove_column :variabili, :forza_zero
    end
  end
end 