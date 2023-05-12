class AddPublishToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :publish, :boolean, default: false
  end
end
