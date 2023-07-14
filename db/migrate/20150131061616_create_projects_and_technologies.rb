class CreateProjectsAndTechnologies < ActiveRecord::Migration[5.2]
  def self.up
    create_table :projects_technologies, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :technology, index: true
    end
  end

  def self.down
    drop_table :projects_technologies
  end
end
