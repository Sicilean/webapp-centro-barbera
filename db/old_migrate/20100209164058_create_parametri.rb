class CreateParametri < ActiveRecord::Migration
  def self.up
    create_table(:parametri, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8') do |t|
      t.string :codice
      t.string :nome
      t.string :note
      t.text   :valore, :default => '', :null => false # così sono sicuro che non ho nil in giro

      t.timestamps
    end
  end

  def self.down
    drop_table :parametri
  end
end
