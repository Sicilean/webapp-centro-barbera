class CreateCampioneTipologiaItems < ActiveRecord::Migration
  def self.up
    create_table(:campione_tipologia_items, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.integer :campione_id
      t.integer :tipologia_id
      t.float  :prezzo, :default => 0 # TIENILO FLOAT altimenti active scaff fa casino;  we store the prince in cents! Vedi Agile p. 90

      t.timestamps
    end
  end

  def self.down
    drop_table :campione_tipologia_items
  end
end
