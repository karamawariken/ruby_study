class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :in_reply_to, class_name: "User", foreign_key: "in_reply_to"
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }
  scope :including_replies, lambda { |user| from_users_followed_by(user) }

  #バリデーションに成功し、オブジェクト保存された後呼ばれる。insertどちらとも呼ばれる
  #update時にも行う場合before_saveになる今はマイクロポストの編集がないためcreateのみとしている
  before_create :reply_to_user

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

  private

    def reply_to_user
      #もっと簡単に
      if match_check = self.content.match(/(@[\w+-.]*)/i)
        @reply_to_user_name = match_check[1].to_s
        @reply_to_user_name.slice!("@")
        @reply_to_user = User.where(nickname: @reply_to_user_name)
        if @reply_to_user
          self.in_reply_to = @reply_to_user[0]
        end
      end
    end
end
