class AddPositionToTechnologies < ActiveRecord::Migration
  def change
    add_column :technologies, :position, :integer
  end
end
