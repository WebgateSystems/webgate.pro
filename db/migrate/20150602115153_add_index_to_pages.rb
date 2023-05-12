class AddIndexToPages < ActiveRecord::Migration[7.0]
  def change
    add_index :pages, :category_id
  end
end
