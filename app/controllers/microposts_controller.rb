class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
    @message_or_micropost_model = create_model(micropost_params)
    if @message_or_micropost_model.save
      flash[:success] = "success"
    else
      flash[:error] = "error"
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

    def find_recipient_user_nick_name(nick_name)
      User.find_by(nickname: nick_name)
    end

    def create_model(micropost)
      if reply_to_user_name = micropost[:content].match(/^d[\s\u3000]+@(\w+)[\s\u3000]*(\S*)/i)
        if reply_to_user_name[2].present? && reply_to_user = User.find_by(nickname: reply_to_user_name[1])
          @message = Message.new(sender_id: current_user.id,reciptient_id: reply_to_user.id ,content: micropost[:content])
        else
          @message = Message.new()
        end
      else
        reply_to_user_name = micropost[:content].match(/@(\w+)/i)
        micropost["in_reply_to"] = User.find_by(nickname: reply_to_user_name[1]) if reply_to_user_name
        @micropost = current_user.microposts.build(micropost)
      end
    end
end
