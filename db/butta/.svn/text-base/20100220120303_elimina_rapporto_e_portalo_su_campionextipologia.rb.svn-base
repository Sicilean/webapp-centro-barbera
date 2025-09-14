class EliminaRapportoEPortaloSuCampionextipologia < ActiveRecord::Migration
  def self.up
    drop_table  :rapporti
    add_column   :campione_tipologia_items,   :numero, :integer
    add_column   :campione_tipologia_items,   :data,   :date
    add_column   :campione_tipologia_items,   :note,   :string
  end

  def self.down
    create_table(:rapporti, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :campione_id
      t.integer :numero
      t.date :data
      t.string :note

      t.timestamps
    end
    remove_column :campione_tipologia_items,   :numero
    remove_column :campione_tipologia_items,   :data
    remove_column :campione_tipologia_items,   :note
  end
end
