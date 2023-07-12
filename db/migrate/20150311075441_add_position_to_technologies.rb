class AddPositionToTechnologies < ActiveRecord::Migration[5.2]
  def change
    add_column :technologies, :position, :integer
  end
end
