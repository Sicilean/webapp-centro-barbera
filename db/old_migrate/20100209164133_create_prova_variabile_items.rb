class CreateProvaVariabileItems < ActiveRecord::Migration
  def self.up
    create_table(:prova_variabile_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :prova_id
      t.integer :variabile_id
      t.boolean :da_mostrare

      t.timestamps
    end
  end

  def self.down
    drop_table :prova_variabile_items
  end
end
