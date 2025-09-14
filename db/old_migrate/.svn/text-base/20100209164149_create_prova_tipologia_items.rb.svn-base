class CreateProvaTipologiaItems < ActiveRecord::Migration
  def self.up
    create_table(:prova_tipologia_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :prova_id
      t.integer :tipologia_id

      t.timestamps
    end
  end

  def self.down
    drop_table :prova_tipologia_items
  end
end
