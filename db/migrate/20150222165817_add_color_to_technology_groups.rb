class AddColorToTechnologyGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :technology_groups, :color, :string
  end
end
