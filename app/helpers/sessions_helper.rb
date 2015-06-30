module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    #ブラウザのcookiesをハッシュのように扱うことができる
    cookies.permanent[:remember_token] = remember_token
    #update_attributeの利用により、検証せずに単一の属性を更新できる。
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    #コントローラーとビューどちらからもアクセスできるインスタンス生成
    self.current_user = user
  end

  #セッター用
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    #@current_user || @current_user = User ~ と同じ意味　存在を確認後,ない場合は代入し@current_userがある場合はそちらを評価する
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  #ログインチェックメソッド
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    #値がnilでなければsession[:return_to]を評価しnilであればdefaultを使用する
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  #前のページを覚えておく
  def store_location
    session[:return_to] = request.url
  end

  #flashでは、successとnoticeとerrorを設定できる
  #Userだけではなく、Micropostsコントローラでも利用するためhelperに移動した
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  #APIkeyを所持しているかどうかを取得
  def have_api_key?(access_token)
    if access_token && ApiKey.find_by(access_token: access_token["token"])
      true
    else
      false
    end
  end

  def check_token?(format)
    if format == "xml"
      have_api_key?(JSON.parse(request.headers[:HTTP_AUTHORIZATION]))
    else
      true
    end
  end
end
