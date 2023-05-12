class AddPublishToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :publish, :boolean, default: false
  end
end
