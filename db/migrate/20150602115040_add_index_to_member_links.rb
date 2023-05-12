class AddIndexToMemberLinks < ActiveRecord::Migration[7.0]
  def change
    add_index :member_links, :member_id
  end
end
