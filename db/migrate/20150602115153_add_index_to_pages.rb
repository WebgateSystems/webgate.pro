class AddIndexToPages < ActiveRecord::Migration
  def change
    add_index :pages, :category_id
  end
end
