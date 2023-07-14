class CreateTechnologiesProjects < ActiveRecord::Migration[5.2]
  def self.up
    create_table :technologies_projects do |t|
      t.belongs_to :project, index: true
      t.belongs_to :technology, index: true
      t.integer :position
    end
    add_index :technologies_projects, %i[project_id technology_id], unique: true
  end

  def self.down
    drop_table :technologies_projects
  end
end
