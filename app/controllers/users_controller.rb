class UsersController < ApplicationController
  #ユーザにサインインを要求するために以下メソッドを定義して呼び出す
  #only ではアクションを限定している
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  skip_before_filter :verify_authenticity_token


  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    #html形式であれば、このまま通る
    if check_token?(params[:format])
      respond_to do |format|
        format.html
        format.xml { render xml: @user}
      end
    else
      head :bad_request
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def edit
  end

  def update
    #update_attributes属性を更新するメソッド
    if @user.update_attributes(user_update_params)
      #更新に成功した場合に扱う
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    #ここにadminを入れないことにより任意のユーザが自分自身にアプリケーションの管理者権限を与えることを防止している
    def user_params
      params.require(:user).permit(:name, :email, :nickname, :password, :password_confirmation)
    end

    def user_update_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    #管理者か確認
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
