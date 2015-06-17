class SessionsController < ApplicationController
  include SessionsHelper
  def new
  end

  def create
    #メールアドレスは、小文字で保存させているので、ここでdowncaseにして正しいかの検出を行う.
    user = User.find_by(email:params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #ユーザをサインインさせ、ユーザページ(show)にリダイレクトする
      sign_in user
      redirect_to user
    else
      #エラーメッセージを表示し、サインインフォームを再描画する
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
