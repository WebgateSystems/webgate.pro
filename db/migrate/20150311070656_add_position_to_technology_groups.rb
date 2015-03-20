class AddPositionToTechnologyGroups < ActiveRecord::Migration
  def change
    add_column :technology_groups, :position, :integer
  end
end
