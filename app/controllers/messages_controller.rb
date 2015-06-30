class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  #会話の中身を見る
  def show
    @message = current_user.messages.build(sender_id: current_user.id, reciptient_id: params[:id])
    @messages = Message.find_conversation(current_user.id,params[:id])
    if @messages.empty?
      flash[:error] = "メッセージがないか、相手がいません"
      redirect_to users_path
    end
  end

  #メッセージ作成
  def create
    @message = Message.new(message_params)
    if @message.save
      flash[:success] = "success"
    else
      flash[:error] = "error"
    end
    redirect_to message_path(@message.reciptient_user)
  end

  def destroy
    reciptient_user = @message.reciptient_user
    @message.destroy
    redirect_to message_path(reciptient_user)
  end

  private

  def correct_user
    #findでは、値がない場合例外が発生するため find_byにしてnilを渡させる
    @message = current_user.messages.find_by(id: params[:id])
    redirect_to root_url if @message.nil?
  end

  def message_params 
    params.require(:message).permit(:content, :sender_id, :reciptient_id)
  end
end
