class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :stream_events, :type, :item_type
  end
end
