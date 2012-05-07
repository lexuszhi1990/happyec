class RemoveImageurlFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :image_url
  end

  def down
    add_column :users, :image_url, :string
  end
end
