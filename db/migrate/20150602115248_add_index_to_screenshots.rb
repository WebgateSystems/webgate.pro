class AddIndexToScreenshots < ActiveRecord::Migration[7.0]
  def change
    add_index :screenshots, :project_id
  end
end
