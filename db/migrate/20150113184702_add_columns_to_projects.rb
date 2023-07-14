class AddColumnsToProjects < ActiveRecord::Migration[5.2]
  def self.up
    add_column :projects, :livelink, :string
    add_column :projects, :publish, :boolean, default: false
  end

  def self.down
    remove_column :projects, :livelink
    remove_column :projects, :publish
  end
end
