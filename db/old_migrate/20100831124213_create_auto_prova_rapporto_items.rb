class CreateAutoProvaRapportoItems < ActiveRecord::Migration
  def self.up
    create_table(:auto_prova_rapporto_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|

      t.integer :prova_id
      t.integer :rapporto_id
      t.float :prezzo

      t.timestamps
    end
  end

  def self.down
    drop_table :auto_prova_rapporto_items
  end
end
