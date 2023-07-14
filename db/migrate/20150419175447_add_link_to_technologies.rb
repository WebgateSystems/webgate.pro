class AddLinkToTechnologies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :technologies, :link, :string
    Technology.add_translation_fields! link: :string
  end

  def self.down
    remove_column :technologies, :link
  end
end
