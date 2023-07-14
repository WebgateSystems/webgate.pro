class SorceryBruteForceProtection < ActiveRecord::Migration[5.2]
  def self.up
    add_column :users, :failed_logins_count, :integer, default: 0
    add_column :users, :lock_expires_at, :datetime, default: nil
    add_column :users, :unlock_token, :string, default: nil
  end

  def self.down
    remove_column :users, :failed_logins_count
    remove_column :users, :lock_expires_at
    remove_column :users, :unlock_token
  end
end
