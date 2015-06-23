class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  #followed_usersで relationshipsのfollower_idから関連を経由して、followedで定義されるデータを引っ張ってくる
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { email.downcase! }
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  #presence 値が空ではないか
  validates :name,  presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
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
    #SQLインジェクションの防止 id がクエリに入る前にエスケープされる
    Micropost.where("user_id = ?", id)
    Micropost.from_users_followed_by(self)
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
