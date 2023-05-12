class AddPositionToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :position, :integer
  end
end
