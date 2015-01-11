class CreateTechnologyGroups < ActiveRecord::Migration
  def self.up
    create_table :technology_groups do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
    TechnologyGroup.create_translation_table! title: :string, description: :text
  end

  def self.down
    TechnologyGroup.drop_translation_table!
    drop_table :technology_groups
  end
end
