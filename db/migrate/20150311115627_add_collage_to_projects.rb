class AddCollageToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :collage, :string
  end
end
