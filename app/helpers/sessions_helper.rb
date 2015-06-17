module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
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

  #ログインチェックメソッド
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
