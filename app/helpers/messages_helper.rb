module MessagesHelper
  def hide_nick_name(content)
    if match_words = content.match(/^(d[\s\u3000\b]+@\w+)/i)
      content.slice!(match_words[1])
    end
    content
  end
end
