class SessionsController < ApplicationController
  def new
  end

  def create
    #メールアドレスは、小文字で保存させているので、ここでdowncaseにして正しいかの検出を行う.
    #form_tagによりパラメータ変更
    user = User.find_by(email:params[:email].downcase)
    if user && user.authenticate(params[:password])
      #ユーザをサインインさせ、ユーザページ(show)にリダイレクトする
      sign_in user
      redirect_back_or user
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
