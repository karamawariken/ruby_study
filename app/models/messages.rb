class Messages < ActiveRecord::Base
  belongs_to :sender_user, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient_user, class_name: "User", foreign_key: "reciptient_id"
  #降順　new→oldの順
  default_scope -> { order('created_at DESC') }
end
