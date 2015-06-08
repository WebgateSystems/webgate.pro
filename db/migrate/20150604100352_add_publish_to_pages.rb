class AddPublishToPages < ActiveRecord::Migration
  def change
    add_column :pages, :publish, :boolean, default: false
  end
end
