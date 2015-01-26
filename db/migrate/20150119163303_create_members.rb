class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.text :shortdesc
      t.text :description
      t.text :motto
      t.string :avatar

      t.timestamps
    end
    Member.create_translation_table! name: :string,  shortdesc: :text,
                                     description: :text, motto: :text
  end

  def self.down
    Member.drop_translation_table!
    drop_table :members
  end
end