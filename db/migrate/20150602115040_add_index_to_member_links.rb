class AddIndexToMemberLinks < ActiveRecord::Migration
  def change
    add_index :member_links, :member_id
  end
end
