class AddPublishToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :publish, :boolean, default: false
  end
end
