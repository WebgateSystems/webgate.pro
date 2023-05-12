class AddPositionToTechnologyGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :technology_groups, :position, :integer
  end
end
