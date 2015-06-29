module MessagesHelper
  def hide_nick_name(content)
    match_words = content.match(/^(d\s+?@[\w+-.]*)/i)
    content.delete("#{match_words[1]}")
  end
end
