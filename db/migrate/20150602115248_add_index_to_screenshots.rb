class AddIndexToScreenshots < ActiveRecord::Migration
  def change
    add_index :screenshots, :project_id
  end
end
