class AddColorToTechnologyGroups < ActiveRecord::Migration[5.2]
  def self.up
    add_column :technology_groups, :color, :string
  end

  def self.down
    remove_column :technology_groups, :color
  end
end
