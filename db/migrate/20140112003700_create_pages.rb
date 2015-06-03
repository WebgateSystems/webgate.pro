class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :shortlink
      t.string :title
      t.text :description
      t.text :keywords
      t.text :content
      t.integer :position
      t.belongs_to :category
      t.timestamps
    end
    Page.create_translation_table! title: :string, shortlink: :string, description: :text,
                                   keywords: :text, content: :text, tooltip: :text
  end

  def self.down
    Page.drop_translation_table!
    drop_table :pages
  end
end
