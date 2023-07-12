class CreateProjects < ActiveRecord::Migration[5.2]
  def self.up
    create_table :projects do |t|
      t.string :shortlink
      t.string :title
      t.text :description
      t.text :keywords
      t.text :content
      t.string :screenshot1
      t.string :screenshot2
      t.string :screenshot3

      t.timestamps
    end
    Project.create_translation_table! title: :string, content: :text
  end

  def self.down
    Project.drop_translation_table!
    drop_table :projects
  end
end
