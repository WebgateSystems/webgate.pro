class AddIndexToMemberLinks < ActiveRecord::Migration[5.2]
  def change
    add_index :member_links, :member_id
  end
end
