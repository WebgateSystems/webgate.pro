class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :livelink, :string
    add_column :projects, :publish, :boolean, default: false
  end
end
