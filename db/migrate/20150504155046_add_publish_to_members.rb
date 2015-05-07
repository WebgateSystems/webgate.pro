class AddPublishToMembers < ActiveRecord::Migration
  def change
    add_column :members, :publish, :boolean, default: false
  end
end
