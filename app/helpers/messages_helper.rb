module MessagesHelper
  def message_check(micropost)
    direct_message_match = /^d(.+?)(@[\w+-.]*)/i
    #ここでメッセージとの判別を行う
    #puts "aaa" if micropost[:content].match(direct_message_match)
  end
end
