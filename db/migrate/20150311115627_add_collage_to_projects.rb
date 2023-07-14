class AddCollageToProjects < ActiveRecord::Migration[5.2]
  def self.up
    add_column :projects, :collage, :string
  end

  def self.down
    remove_column :projects, :collage
  end
end
