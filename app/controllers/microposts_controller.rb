class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy
  before_action :reply_to_user, only: :create

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :in_reply_to)
    end

    def correct_user
      #findでは、値がない場合例外が発生するため find_byにしてnilを渡させる
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def reply_to_user
      @micropost = current_user.microposts.build(micropost_params)
      if reply_to = @micropost.content.match(/(@[\w+\-.]*)/i)
        @other_user = User.where(name: reply_to.to_s[1..-1])
        if @other_user && current_user.followed_users.includes(@other_user)
          @micropost.in_reply_to = @other_user.id
        end
      end
      raise @micropost.inspect
    end
end
