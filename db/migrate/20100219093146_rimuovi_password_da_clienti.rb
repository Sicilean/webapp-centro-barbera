class RimuoviPasswordDaClienti < ActiveRecord::Migration
  def self.up
    #remove_column :users,    :street
    remove_column :clienti,   :password
    rename_column :clienti,   :email, :email_per_notifiche
  end

  def self.down
     add_column :clienti, :password, :string
     rename_column :clienti, :email_per_notifiche, :email
  end
end
