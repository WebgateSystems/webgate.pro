class AddLinkToTechnologies < ActiveRecord::Migration[5.2]
  def up
    add_column :technologies, :link, :string
    Technology.add_translation_fields! link: :string
  end

  def down
    remove_column :technologies, :link
  end
end
