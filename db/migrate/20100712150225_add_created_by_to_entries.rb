class AddCreatedByToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :created_by, :string
  end

  def self.down
    remove_column :entries, :created_by
  end
end
