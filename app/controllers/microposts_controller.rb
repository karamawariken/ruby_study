class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      reply_to_user(@micropost)
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
      params.require(:micropost).permit(:content)
    end

    def correct_user
      #findでは、値がない場合例外が発生するため find_byにしてnilを渡させる
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def reply_to_user(micropost)
      if reply_to = micropost.content.match(/(@[\w+-.]*)/i)
        search_name = reply_to[1].to_s
        search_name.slice!("@")
        @other_user = User.where(name: search_name)
        if @other_user && current_user.followed_users.includes(@other_user)
          micropost.update_columns(in_reply_to: @other_user[0].id)
        end
      end
    end
end
