class CreateTechnologiesMembers < ActiveRecord::Migration
  def change
    create_table :technologies_members do |t|
      t.belongs_to :member, index: true
      t.belongs_to :technology, index: true
      t.integer :position
    end
    add_index :technologies_members, [:member_id, :technology_id], unique: true
  end
end
