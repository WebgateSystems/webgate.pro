class AddPositionToTechnologyGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :technology_groups, :position, :integer
  end
end
