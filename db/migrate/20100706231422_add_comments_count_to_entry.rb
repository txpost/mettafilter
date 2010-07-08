class AddCommentsCountToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :comments_count, :integer,
      :default => 0
  end

  def self.down
    remove_column :entries, :comments_count
  end
end
