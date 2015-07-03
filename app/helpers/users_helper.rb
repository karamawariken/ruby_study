module UsersHelper
  #与えられたユーザのGravatar( http://gravatar_forvatar.com/)を返す。
  def gravatar_for(user, options = { size:50 })
    #Digestクラスでは、hexdigest(str)->String ：与えらた文字列に対するハッシュ値をASCIIコードを使って16進数の列を示す文字列にエンコードして返す。
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def add_reply_user_page_link(micropost)
    reply_user = micropost[:content].match(/(@\w+)/i)
    if micropost.in_reply_to.present?
      split_content = micropost[:content].split(reply_user[1],2)
      edit_content = h(split_content[0]) + link_to(reply_user, micropost.in_reply_to) + h(split_content[1])
    else
      micropost.content
    end
  end
end
