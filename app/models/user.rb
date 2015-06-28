class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :replies, foreign_key: "in_reply_to", class_name: "Micropost", dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  #follow/ed_idを主キーとして渡すことでreverse_relationshipsをシミュレートするための１行
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  VALID_NAMENICK_REGEX = /[^\w]/
  VALID_EMAIL_REGEX = /\A[\w+-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  #presence 値が空ではないか case_sensitive 大文字小文字を区別するか
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :nickname, presence: true, length: { maximum: 15 }, format: { without: VALID_NAMENICK_REGEX ,message: "Nick Nameは、英数字と'_'(アンダーバー)のみ使えます"}, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  #以下設定により、認証メソッドなどが使用できる
  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    #返信機能のため以下コメントにして、スコープ追加
    #Micropost.from_users_followed_by(self)
    Micropost.including_replies(self)
  end

  # following?メソッドはother_userという1人のユーザーを引数にとり、
  # フォローする相手のユーザーがデータベース上に存在するかどうかをチェックします。
  # follow!メソッドは、relationships関連付けを経由してcreate!を呼び出す
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
