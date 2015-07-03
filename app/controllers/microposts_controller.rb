class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
    @message_or_micropost = create_model(micropost_params)
    if @message_or_micropost.present?
      if @message_or_micropost.save
        flash[:success] = "success"
      else
        flash[:error] = "error"
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

    def create_model(micropost)
      if split_content = micropost[:content].match(/^d[[:space:]]+@(\w+)[[:space:]]*(\S*)/i)
        create_conversation_and_message(micropost, split_content)
      else
        split_content = micropost[:content].match(/@(\w+)/i)
        micropost["in_reply_to"] = User.find_by(nickname: split_content[1]) if split_content
        @micropost = current_user.microposts.build(micropost)
      end
    end
end
