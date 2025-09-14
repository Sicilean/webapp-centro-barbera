class AggiungoAmministratore < ActiveRecord::Migration
  def self.up
    User.create(        :nome => 'Francesco Ronzon',
                        :email =>"info@centrobarbera.it",
                        :password => 'barbera',
                        :password_confirmation => 'barbera',
                        :role => 10)
    User.create(        :nome => 'Massimiliano Barbera',
                        :email =>"maxcentroenochimico@tiscali.it",
                        :password => 'barbera',
                        :password_confirmation => 'barbera',
                        :role => 10)
  end

  def self.down
    User.delete_all
  end
end
