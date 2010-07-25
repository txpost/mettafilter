class CreateFavcoms < ActiveRecord::Migration
  def self.up
    create_table :favcoms do |t|
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :favcoms
  end
end
