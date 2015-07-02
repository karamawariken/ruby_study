class Message < ActiveRecord::Base
  belongs_to :sender_user, class_name: "User", foreign_key: "sender_id"
  belongs_to :reciptient_user, class_name: "User", foreign_key: "reciptient_id"
  belongs_to :conversation
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }

  validates :content, presence: true, length: {maximum: 140 }
  validates :sender_id, presence: true
  validates :reciptient_id, presence: true

  def self.find_conversation(sender_id, reciptient_id)
    where("(sender_id = :sender_id AND reciptient_id = :reciptient_id) OR (sender_id = :reciptient_id AND reciptient_id = :sender_id)", sender_id: sender_id, reciptient_id: reciptient_id)
  end

  def self.find_unread(sender_id, reciptient_id)
    #booleanでは false : f  true : tが値となる
    messages = self.where("(sender_id = :reciptient_id AND reciptient_id = :sender_id AND read = :read)", sender_id: sender_id, reciptient_id: reciptient_id, read: "f")
    if messages.present?
      messages.each do |message|
        message.update(read: "t")
      end
    end
  end
end
