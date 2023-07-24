class CreateBlacklists < ActiveRecord::Migration[7.0]
  def self.up
    create_table :blacklists do |t|
      t.string :ip, null: false

      t.timestamps
    end
  end

  def self.down
    drop_table :blacklists
  end
end
