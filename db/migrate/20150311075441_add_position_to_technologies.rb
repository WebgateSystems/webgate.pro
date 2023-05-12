class AddPositionToTechnologies < ActiveRecord::Migration[7.0]
  def change
    add_column :technologies, :position, :integer
  end
end
