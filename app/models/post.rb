class Post < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :on => :create
  after_create { update_stream }
 
  def update_stream
     @stream_event = StreamEvent.new
     @stream_event.itemId = self.id
     @stream_event.userId = self.user.id
     @stream_event.type = "POST"
     @stream_event.time = self.created_at
     @stream_event.save
  end

end
