class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  has_ancestry

end
