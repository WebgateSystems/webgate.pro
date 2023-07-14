class CreateTechnologiesMembers < ActiveRecord::Migration[5.2]
  def self.up
    create_table :technologies_members do |t|
      t.belongs_to :member, index: true
      t.belongs_to :technology, index: true
      t.integer :position
    end

    add_index :technologies_members, %i[member_id technology_id], unique: true
  end

  def self.down
    drop_table :technologies_members
  end
end
