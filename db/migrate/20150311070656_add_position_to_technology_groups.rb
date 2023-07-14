class AddPositionToTechnologyGroups < ActiveRecord::Migration[5.2]
  def self.up
    add_column :technology_groups, :position, :integer
  end

  def self.down
    remove_column :technology_groups, :position
  end
end
