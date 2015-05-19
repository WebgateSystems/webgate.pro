class CreateTechnologiesProjects < ActiveRecord::Migration
  def change
    create_table :technologies_projects do |t|
      t.belongs_to :project, index: true
      t.belongs_to :technology, index: true
      t.integer :position
    end
  end
end
