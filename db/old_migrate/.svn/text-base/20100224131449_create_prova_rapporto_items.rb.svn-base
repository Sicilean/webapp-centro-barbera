class CreateProvaRapportoItems < ActiveRecord::Migration
  def self.up
    create_table(:prova_rapporto_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|

      t.integer :prova_id
      t.integer :rapporto_id
      t.float :prezzo, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :prova_rapporto_items
  end
end
