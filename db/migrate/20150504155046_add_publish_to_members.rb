class AddPublishToMembers < ActiveRecord::Migration[5.2]
  def self.up
    add_column :members, :publish, :boolean, default: false
  end

  def self.down
    remove_column :members, :publish
  end
end
