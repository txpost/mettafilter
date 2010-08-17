class ChangeUserColumns < ActiveRecord::Migration
  def self.up
    rename_column :users, :name, :login
    rename_column :users, :hashed_password, :crypted_password
    rename_column :users, :salt, :password_salt
    add_column :users, :persistence_token, :string
  end

  def self.down
    rename_column :users, :login, :name
    rename_column :users, :crypted_password, :hashed_password
    rename_column :users, :password_salt, :salt
    remove_column :users, :persistence_token
  end
end
