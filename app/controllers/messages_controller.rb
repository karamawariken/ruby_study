class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  #会話の中身を見る
  def show
    Message.update_read(current_user.id,params[:id])
    @message = current_user.messages.build(sender_id: current_user.id, reciptient_id: params[:id])
    @messages = Message.find_conversation(current_user.id,params[:id]).paginate(page: params[:page], :per_page => 10)
    if @messages.empty?
      flash[:error] = "nothing user or messages"
      redirect_to conversations_path
    end
  end

  #メッセージ作成
  def create
    @conversation = find_or_create_conversation(current_user,User.find_by(id: message_params[:reciptient_id]))
    @message = Message.new(message_params)
    @message.conversation_id = @conversation.id
    @message.read = false
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
