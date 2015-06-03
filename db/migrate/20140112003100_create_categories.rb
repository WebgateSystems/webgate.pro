class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :altlink
      t.text :description
      t.integer :position
      t.timestamps
    end
    Category.create_translation_table! name: :string, altlink: :string, description: :text
  end

  def self.down
    Category.drop_translation_table!
    drop_table :categories
  end
end
