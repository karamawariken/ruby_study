module ConversationHelper
  def find_conversation(user1, user2)
    if user1.id < user2.id
      low_user = user1
      high_user = user2
    else
      low_user = user2
      high_user = user1
    end
    if Conversation.find_by(low_user_id: low_user.id, high_user_id: high_user.id).present?
      @conversation = Conversation.find_by(low_user_id: low_user.id, high_user_id: high_user.id)
    else
      @conversation = Conversation.create!(low_user_id: low_user.id, high_user_id: high_user.id)
    end    
  end
end
