# frozen_string_literal: true

class AddPublishedOnToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :published_on, :date
    add_index :projects, :published_on
  end
end
