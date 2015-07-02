class Conversation < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  belongs_to :low_user, class_name: "User", foreign_key: "low_user_id"
  belongs_to :high_user, class_name: "User", foreign_key: "high_user_id"
  validates :low_user_id, presence: true
  validates :high_user_id, presence: true

  default_scope -> { order('updated_at DESC') }

  def self.current_user_conversation(user)
    where("low_user_id = :user_id OR high_user_id = :user_id", user_id: user.id)
  end

end
