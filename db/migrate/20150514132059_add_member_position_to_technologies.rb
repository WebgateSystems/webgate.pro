class AddMemberPositionToTechnologies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :technologies, :member_position, :integer
  end

  def self.down
    remove_column :technologies, :member_position
  end
end
