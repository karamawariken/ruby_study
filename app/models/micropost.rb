class Micropost < ActiveRecord::Base
  belongs_to :user
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: {maximum: 140 }
  validates :user_id, presence: true
end
