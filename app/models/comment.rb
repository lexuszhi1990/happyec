class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates_presence_of :content
  has_ancestry
  after_create { update_stream }
 
  def update_stream
     @stream_event = StreamEvent.new
     @stream_event.itemId = self.id
     @stream_event.userId = self.user.id
     @stream_event.item_type = "COMMENT"
     @stream_event.time = self.created_at
     @stream_event.save
  end
end
