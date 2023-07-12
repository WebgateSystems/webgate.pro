class DeleteLinkTranslations < ActiveRecord::Migration[5.2]
  def up
    drop_table :link_translations
  end

  def down
    create_table :link_translations do |t|
      t.string :link
      t.string :locale
      t.string :link_type

      t.timestamps
    end
  end
end
