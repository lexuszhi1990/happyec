class AddEndtimeToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :endtime, :datetime
  end

  def self.down
    remove_column :events, :endtime
  end
end
