class RemoveColumnsFromProjects < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :projects, :screenshot1, :string
    remove_column :projects, :screenshot2, :string
    remove_column :projects, :screenshot3, :string
  end

  def self.down
    add_column :projects, :screenshot1, :string
    add_column :projects, :screenshot2, :string
    add_column :projects, :screenshot3, :string
  end
end
