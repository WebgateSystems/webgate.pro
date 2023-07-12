class AddPositionToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :position, :integer
  end
end
