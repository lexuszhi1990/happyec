class RemoveEndtimeFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :endtime
  end

  def down
    add_column :events, :endtime, :datetime
  end
end
