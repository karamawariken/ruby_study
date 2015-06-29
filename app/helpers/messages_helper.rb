module MessagesHelper
  def message_check(micropost)
    direct_message_match = /^d(\s+?)@([\w+-.]*)/i
    #ここでメッセージとの判別を行う
    if reply_to_user_name = micropost[:content].match(direct_message_match)
      reply_to_user = find_recipient_user(reply_to_user_name[2])
      message_detail = { sender_id: current_user.id,reciptient_id: reply_to_user.id ,content: micropost[:content], read: false }
    end
  end


  def find_recipient_user(word)
    User.find_by(nickname: word)
  end
end
