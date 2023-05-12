class AddPositionToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :position, :integer
  end
end
