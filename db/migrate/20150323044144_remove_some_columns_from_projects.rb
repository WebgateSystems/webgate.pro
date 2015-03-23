class RemoveSomeColumnsFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :shortlink, :string
    remove_column :projects, :description, :text
    remove_column :projects, :keywords, :text

    remove_column :project_translations, :shortlink
    remove_column :project_translations, :description
    remove_column :project_translations, :keywords
  end
end
