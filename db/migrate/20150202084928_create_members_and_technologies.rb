class CreateMembersAndTechnologies < ActiveRecord::Migration[5.2]
  def self.up
    create_table :members_technologies, id: false do |t|
      t.belongs_to :member, index: true
      t.belongs_to :technology, index: true
    end
  end

  def self.down
    drop_table :members_technologies
  end
end
