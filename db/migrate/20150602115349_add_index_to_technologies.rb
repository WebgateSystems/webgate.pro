class AddIndexToTechnologies < ActiveRecord::Migration
  def change
    add_index :technologies, :technology_group_id
  end
end
