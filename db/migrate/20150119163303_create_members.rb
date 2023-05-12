class CreateMembers < ActiveRecord::Migration[7.0]
  def self.up
    create_table :members do |t|
      t.string :name
      t.text :education
      t.text :description
      t.text :motto
      t.string :avatar

      t.timestamps
    end
    Member.create_translation_table! name: :string, education: :text,
                                     description: :text, motto: :text
  end

  def self.down
    Member.drop_translation_table!
    drop_table :members
  end
end
