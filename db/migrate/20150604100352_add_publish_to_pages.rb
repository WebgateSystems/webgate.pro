class AddPublishToPages < ActiveRecord::Migration[5.2]
  def self.up
    add_column :pages, :publish, :boolean, default: false
  end

  def self.down
    remove_column :pages, :publish
  end
end
