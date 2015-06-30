class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :in_reply_to, class_name: "User", foreign_key: "in_reply_to"
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }
  scope :including_replies, lambda { |user| from_users_followed_by(user) }


  validates :content, presence: true, length: {maximum: 140 }
  validates :user_id, presence: true

  # 以下のマイクロポストを表示する
  # 1.自分のマイクロソフト, 2.フォローしているユーザー達のマイクロポスト, 3.replyユーザに自分のuser_idが入っているマイクロポスト。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR in_reply_to = :user_id",
          user_id: user.id)
  end
end
