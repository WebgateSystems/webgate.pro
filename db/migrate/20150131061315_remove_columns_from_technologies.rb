class RemoveColumnsFromTechnologies < ActiveRecord::Migration[5.2]
  def change
    remove_column :technologies, :taggable_id, :integer
    remove_column :technologies, :taggable_type, :string
  end
end
