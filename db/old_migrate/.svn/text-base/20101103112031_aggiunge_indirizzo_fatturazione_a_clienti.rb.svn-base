class AggiungeIndirizzoFatturazioneAClienti < ActiveRecord::Migration
  def self.up
    add_column   :clienti, :fatt_indirizzo, :string
    add_column   :clienti, :fatt_comune, :string
    add_column   :clienti, :fatt_cap, :string
    add_column   :clienti, :fatt_provincia, :string
  end

  def self.down
    remove_column :clienti, :fatt_indirizzo
    remove_column :clienti, :fatt_comune
    remove_column :clienti, :fatt_cap
    remove_column :clienti, :fatt_provincia
  end
end
