class RemoveColumnsFromTechnologies < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :technologies, :taggable_id, :integer
    remove_column :technologies, :taggable_type, :string
  end

  def self.down
    add_column :technologies, :taggable_id, :integer
    add_column :technologies, :taggable_type, :string
  end
end
