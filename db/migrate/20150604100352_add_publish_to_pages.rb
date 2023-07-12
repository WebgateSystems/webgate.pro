class AddPublishToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :publish, :boolean, default: false
  end
end
