class SorceryCore < ActiveRecord::Migration[5.2]
  def self.up
    create_table :users do |t|
      t.string :email,            null: false
      t.string :crypted_password, null: false
      t.string :salt,             null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def self.down
    drop_table :users
  end
end
