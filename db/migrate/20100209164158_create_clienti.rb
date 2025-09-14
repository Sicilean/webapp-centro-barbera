class CreateClienti < ActiveRecord::Migration
  def self.up
    create_table(:clienti, :options => 'ENGINE=InnoDB DEFAULT CHARSET=UTF8')  do |t|
      t.string :nome
      t.string :denominazione
      t.string :codice
      t.string :indirizzo
      t.string :cap
      t.string :comune
      t.string :provincia
      t.string :partita_iva
      t.string :codice_fiscale
      t.string :tel
      t.string :fax
      t.string :email # poi rinominata in 'email_per_notifiche'
      t.string :cellulare_per_sms
      t.string :titolare_cellulare
      t.string :password  # poi cancellata
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :clienti
  end
end
