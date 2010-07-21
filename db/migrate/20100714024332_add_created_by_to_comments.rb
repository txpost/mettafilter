class AddCreatedByToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :created_by, :string
  end

  def self.down
    remove_column :comments, :created_by
  end
end
