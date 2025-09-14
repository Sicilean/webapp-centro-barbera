class AggiungeUsaIndirizzoDiFatturazioneAFatture < ActiveRecord::Migration
  def self.up
    add_column   :fatture, :usa_indirizzo_di_fatturazione, :boolean, :default => true
  end

  def self.down
    remove_column :fatture, :usa_indirizzo_di_fatturazione
  end
end
