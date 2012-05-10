class RemoveStuffFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :token
    remove_column :users, :qqopenid
  end

  def down
    add_column :users, :qqopenid, :string
    add_column :users, :token, :string
  end
end
