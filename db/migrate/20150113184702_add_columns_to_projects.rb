class AddColumnsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :livelink, :string
    add_column :projects, :publish, :boolean, default: false
  end
end
