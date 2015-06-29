class Messages < ActiveRecord::Base
  belongs_to :sender_user, class_name: "User", foreign_key: "sender_id"
  belongs_to :reciptient_user, class_name: "User", foreign_key: "reciptient_id"
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }

  def self.find_conversation(sender_id, reciptient_id)
    where("(sender_id = :sender_id AND reciptient_id = :reciptient_id) OR (sender_id = :reciptient_id AND reciptient_id = :sender_id)", sender_id: sender_id, reciptient_id: reciptient_id)
  end
end
