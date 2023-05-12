class AddIndexToTechnologies < ActiveRecord::Migration[7.0]
  def change
    add_index :technologies, :technology_group_id
  end
end
