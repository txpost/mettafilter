class AddMoreBodyToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :more_body, :text
  end

  def self.down
    remove_column :entries, :more_body
  end
end
