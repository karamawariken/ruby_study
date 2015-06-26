module MessagesHelper
  def message_check(micropost)
    reply_match = "/^(@[\w+-.]*)/i"
    direct_message_match = "/^d(.+?)(@[\w+-.]*)/i"

    p micropost[:content].match(reply_match)

    puts "aaa" if micropost[:content].match(direct_message_match)
    puts "bbb" if micropost[:content].match(reply_match)
  end

  def reply_user(micropost)
    if micropost.in_reply_to
        @user = micropost.in_reply_to
        link_to("@#{@user.name}", @user)
    else
        @user = nil
    end
  end
end
