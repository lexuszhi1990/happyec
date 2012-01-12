class AddQqopenidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :qqopenid, :string
  end

  def self.down
    remove_column :users, :qqopenid
  end
end
