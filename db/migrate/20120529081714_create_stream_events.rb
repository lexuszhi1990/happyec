class CreateStreamEvents < ActiveRecord::Migration
  def change
    create_table :stream_events do |t|
      t.integer :userId
      t.integer :itemId
      t.datetime :time
      t.string :type

      t.timestamps
    end
  end
end
