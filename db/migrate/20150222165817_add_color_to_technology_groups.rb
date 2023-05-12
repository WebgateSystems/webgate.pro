class AddColorToTechnologyGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :technology_groups, :color, :string
  end
end
