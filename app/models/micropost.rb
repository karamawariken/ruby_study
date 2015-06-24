class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :in_reply_to, class_name: "User"
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }
  scope :including_replies, lambda { |user| from_users_followed_by(user) }
  #scope :from_users_followed_by_including_replies, lambda { |user| followed_by_including_replies(user) }

  validates :content, presence: true, length: {maximum: 140 }
  validates :user_id, presence: true

  # 与えられたユーザーがフォローしているユーザー達のマイクロポストを返す。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to = :user_id",
          user_id: user.id)
  end
end
