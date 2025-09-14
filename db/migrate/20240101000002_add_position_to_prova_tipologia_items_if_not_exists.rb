class AddPositionToProvaTipologiaItemsIfNotExists < ActiveRecord::Migration
  def self.up
    begin
      columns = ActiveRecord::Base.connection.columns('prova_tipologia_items')
      column_names = columns.map(&:name)
      
      unless column_names.include?('position')
        add_column :prova_tipologia_items, :position, :integer, :default => 0
        
        # Update the position of existing elements
        execute "UPDATE prova_tipologia_items SET position = id"
      end
    rescue Exception => e
      puts "Error checking for position column: #{e.message}"
    end
  end

  def self.down
    begin
      columns = ActiveRecord::Base.connection.columns('prova_tipologia_items')
      column_names = columns.map(&:name)
      
      if column_names.include?('position')
        remove_column :prova_tipologia_items, :position
      end
    rescue Exception => e
      puts "Error removing position column: #{e.message}"
    end
  end
end 