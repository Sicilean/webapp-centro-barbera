class CreateMatrici < ActiveRecord::Migration
  def self.up
    create_table(:matrici, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.string :nome
      t.string :nome_esteso

      t.timestamps
    end
  end

  def self.down
    drop_table :matrici
  end
end
