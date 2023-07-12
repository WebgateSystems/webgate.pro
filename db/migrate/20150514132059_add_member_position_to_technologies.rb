class AddMemberPositionToTechnologies < ActiveRecord::Migration[5.2]
  def change
    add_column :technologies, :member_position, :integer
  end
end
