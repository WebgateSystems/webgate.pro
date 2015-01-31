class RemoveColumnsFromTechnologies < ActiveRecord::Migration
  def change
    remove_column :technologies, :taggable_id, :integer
    remove_column :technologies, :taggable_type, :string
  end
end
