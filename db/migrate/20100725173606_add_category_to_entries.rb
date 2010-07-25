class AddCategoryToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :category, :string
  end

  def self.down
    remove_column :entries, :category
  end
end
