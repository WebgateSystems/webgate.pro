class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.string :file
      t.integer :project_id
      t.integer :position

      t.timestamps
    end
  end
end
