class AddColorToTechnologyGroups < ActiveRecord::Migration
  def change
    add_column :technology_groups, :color, :string
  end
end
