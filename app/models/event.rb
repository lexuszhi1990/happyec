class Event < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  validates_presence_of :name, :location, :content
  after_create { update_stream }
 
  def update_stream
     @stream_event = StreamEvent.new
     @stream_event.itemId = self.id
     @stream_event.item_type = "EVENT"
     @stream_event.time = self.created_at
     @stream_event.save
  end
end
