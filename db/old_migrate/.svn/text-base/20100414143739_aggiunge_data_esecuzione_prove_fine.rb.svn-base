class AggiungeDataEsecuzioneProveFine < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `barbera_development`.`rapporti` CHANGE COLUMN `data_esecuzione_prove` `data_esecuzione_prove_inizio` DATE  DEFAULT NULL;"
    execute "ALTER TABLE `barbera_development`.`rapporti` ADD COLUMN `data_esecuzione_prove_fine` DATE  DEFAULT NULL AFTER `data_esecuzione_prove_inizio`;"
  end

  def self.down
    execute "ALTER TABLE `barbera_development`.`rapporti` DROP COLUMN `data_esecuzione_prove_fine`;"
    execute "ALTER TABLE `barbera_development`.`rapporti` CHANGE COLUMN `data_esecuzione_prove_inizio` `data_esecuzione_prove` DATE  DEFAULT NULL;"
  end
end
