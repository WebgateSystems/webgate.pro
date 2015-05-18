class CreateTechnologiesMembers < ActiveRecord::Migration
  def change
    create_table :technologies_members do |t|
      t.belongs_to :member, index: true
      t.belongs_to :technology, index: true
      t.integer :position
    end
  end
end
