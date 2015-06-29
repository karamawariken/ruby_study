require 'active_support'
module Content
  extend ActiveSupport::Concern

  def find_recipient_user(word)
    User.find_by(nickname: word)
  end
end
