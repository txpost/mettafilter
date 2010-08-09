class AddFavoritesCountToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :favorites_count, :integer,
      :default => 0
  end

  def self.down
    remove_column :entries, :favorites_count
  end
end
