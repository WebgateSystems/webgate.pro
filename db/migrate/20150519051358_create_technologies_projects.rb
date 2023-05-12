class CreateTechnologiesProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :technologies_projects do |t|
      t.belongs_to :project, index: true
      t.belongs_to :technology, index: true
      t.integer :position
    end
    add_index :technologies_projects, [:project_id, :technology_id], unique: true
  end
end
