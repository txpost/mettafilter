class AddFavcomsCountToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :favcoms_count, :integer,
      :default => 0
  end

  def self.down
    remove_column :comments, :favcoms_count
  end
end
