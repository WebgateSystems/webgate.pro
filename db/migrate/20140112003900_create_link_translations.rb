class CreateLinkTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :link_translations do |t|
      t.string :link
      t.string :locale
      t.string :link_type

      t.timestamps
    end
  end
end
