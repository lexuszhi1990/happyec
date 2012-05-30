class Postcomment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates_presence_of :content
  after_create { update_stream }
 
  def update_stream
     @stream_event = StreamEvent.new
     @stream_event.itemId = self.id
     @stream_event.userId = self.user.id
     @stream_event.item_type = "POSTCOMMENT"
     @stream_event.time = self.created_at
     @stream_event.save
  end
end
