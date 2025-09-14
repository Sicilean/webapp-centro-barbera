class RinominaPrezzoInPrezzoTipologiaForfeitARapporti < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE rapporti CHANGE prezzo prezzo_tipologia_forfeit float"
  end

  def self.down
    execute "ALTER TABLE rapporti CHANGE prezzo_tipologia_forfeit prezzo float"
  end
end
