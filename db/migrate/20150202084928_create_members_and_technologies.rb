class CreateMembersAndTechnologies < ActiveRecord::Migration
  def change
    create_table :members_technologies, id: false do |t|
      t.belongs_to :member, index: true
      t.belongs_to :technology, index: true
    end
  end
end
