class CreateMemberLinks < ActiveRecord::Migration

  def self.up
    create_table :member_links do |t|
      t.string :name
      t.string :logo
      t.string :link
      t.integer :member_id
      t.integer :position

      t.timestamps
    end
    MemberLink.create_translation_table! name: :string
  end

  def self.down
    MemberLink.drop_translation_table!
    drop_table :member_links
  end

end
