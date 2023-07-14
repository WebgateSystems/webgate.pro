class AddPositionToTechnologies < ActiveRecord::Migration[5.2]
  def self.up
    add_column :technologies, :position, :integer
  end

  def self.down
    remove_column :technologies, :position
  end
end
