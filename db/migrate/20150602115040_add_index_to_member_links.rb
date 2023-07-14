class AddIndexToMemberLinks < ActiveRecord::Migration[5.2]
  def self.up
    add_index :member_links, :member_id
  end

  def self.down
    remove_index :member_links, :member_id
  end
end
