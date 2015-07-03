module ConversationsHelper
  def find_or_create_conversation(user1, user2)
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

  def create_conversation_and_message(micropost_or_message, split_content)
    if split_content[2].present? && reciptient_user = User.find_by(nickname: split_content[1])
      @conversation = find_or_create_conversation(current_user,reciptient_user)
      @message = Message.new(sender_id: current_user.id,reciptient_id: reciptient_user.id ,content: micropost_or_message[:content],read: false, conversation_id: @conversation.id)
    end
  end
end
