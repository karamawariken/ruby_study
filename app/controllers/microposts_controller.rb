class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
    message = message_check(micropost_params)
    if message
      @message = current_user.sender_user.build(message)
      if @message.save
        flash[:success] = "Message created!"
      end
    else
      @micropost = current_user.microposts.build(micropost_params)
      if @micropost.save
        flash[:success] = "Micropost created!"
      else
        @feed_items = []
        # render 'static_pages/home'
      end
    end
    redirect_to root_url
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
end
