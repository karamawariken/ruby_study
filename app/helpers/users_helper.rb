module UsersHelper
  #与えられたユーザのGravatar( http://gravatar.com/)を返す。
  def gravator_for(user, options = { size:50 })
    #Digestクラスでは、hexdigest(str)->String ：与えらた文字列に対するハッシュ値をASCIIコードを使って16進数の列を示す文字列にエンコードして返す。
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
