class AddMemberPositionToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :member_position, :integer
  end
end
