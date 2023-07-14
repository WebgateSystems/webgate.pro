class AddPositionToProjects < ActiveRecord::Migration[5.2]
  def self.up
    add_column :projects, :position, :integer
  end

  def self.down
    remove_column :projects, :position
  end
end
