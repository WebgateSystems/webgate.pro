class RemoveColumnsFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :screenshot1, :string
    remove_column :projects, :screenshot2, :string
    remove_column :projects, :screenshot3, :string
  end
end
