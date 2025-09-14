class CreateFatturaRapportoItems < ActiveRecord::Migration
  def self.up
    create_table(:fattura_rapporto_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :fattura_id
      t.integer :rapporto_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fattura_rapporto_items
  end
end
