class AggiungoAmministratore < ActiveRecord::Migration
  def self.up
    User.create(        :nome => 'Centro Enochimico Barbera',
                        :email =>"info@centrobarbera.it",
                        :password => 'barbera2025',
                        :password_confirmation => 'barbera2025',
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
