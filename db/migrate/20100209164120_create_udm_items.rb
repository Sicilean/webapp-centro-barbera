class CreateUdmItems < ActiveRecord::Migration
  def self.up
    create_table(:udm_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.string :nome

      t.timestamps
    end
  end

  def self.down
    drop_table :udm_items
  end
end
