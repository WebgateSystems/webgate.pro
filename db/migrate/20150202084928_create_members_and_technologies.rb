class CreateMembersAndTechnologies < ActiveRecord::Migration[5.2]
  def change
    create_table :members_technologies, id: false do |t|
      t.belongs_to :member, index: true
      t.belongs_to :technology, index: true
    end
  end
end
