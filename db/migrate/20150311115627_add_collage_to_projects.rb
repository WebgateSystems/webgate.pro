class AddCollageToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :collage, :string
  end
end
