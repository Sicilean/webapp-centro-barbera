class AddFatturaIdToRapportiIfNotExists < ActiveRecord::Migration
  def self.up
    begin
      columns = ActiveRecord::Base.connection.columns('rapporti')
      column_names = columns.map(&:name)
      
      unless column_names.include?('fattura_id')
        add_column :rapporti, :fattura_id, :integer
        add_index :rapporti, :fattura_id
      end
    rescue Exception => e
      puts "Error checking for fattura_id column: #{e.message}"
    end
  end

  def self.down
    begin
      columns = ActiveRecord::Base.connection.columns('rapporti')
      column_names = columns.map(&:name)
      
      if column_names.include?('fattura_id')
        remove_column :rapporti, :fattura_id
      end
    rescue Exception => e
      puts "Error removing fattura_id column: #{e.message}"
    end
  end
end 