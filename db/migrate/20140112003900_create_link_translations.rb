class CreateLinkTranslations < ActiveRecord::Migration[5.2]
  def self.up
    create_table :link_translations do |t|
      t.string :link
      t.string :locale
      t.string :link_type

      t.timestamps
    end
  end

  def self.down
    drop_table :link_translations
  end
end
