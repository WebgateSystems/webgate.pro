class CreateTechnologies < ActiveRecord::Migration
  def self.up
    create_table :technologies do |t|
      t.string :title
      t.text :description
      t.belongs_to :technology_group
      t.string :logo
      t.integer :taggable_id
      t.string :taggable_type

      t.timestamps
    end
    Technology.create_translation_table! title: :string, description: :text
  end

  def self.down
    Technology.drop_translation_table!
    drop_table :technologies
  end
end
