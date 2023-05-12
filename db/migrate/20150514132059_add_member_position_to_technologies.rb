class AddMemberPositionToTechnologies < ActiveRecord::Migration[7.0]
  def change
    add_column :technologies, :member_position, :integer
  end
end
