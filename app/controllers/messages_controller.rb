class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  #会話の中身を見る
  def show
    read_check_message = Message.find_unread(current_user.id,params[:id])
    # raise read_check_message.inspect
    @message = current_user.messages.build(sender_id: current_user.id, reciptient_id: params[:id])
    @messages = Message.find_conversation(current_user.id,params[:id]).paginate(page: params[:page], :per_page => 10)
    if @messages.empty?
      flash[:error] = "メッセージがないか、相手がいません"
      redirect_to users_path
    end
  end

  #メッセージ作成
  def create
    @conversation = find_conversation(current_user,User.find_by(id: message_params[:reciptient_id]))
    @message = Message.new(message_params)
    @message.conversation_id = @conversation.id
    @message.read = false
    if @message.save
      flash[:success] = "success"
      @conversation.touch
      @conversation.save
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

  def find_conversation(user1, user2)
    if user1.id < user2.id
      low_user = user1
      high_user = user2
    else
      low_user = user2
      high_user = user1
    end
    if Conversation.find_by(low_user_id: low_user.id, high_user_id: high_user.id).present?
      @conversation = Conversation.find_by(low_user_id: low_user.id, high_user_id: high_user.id)
    else
      @conversation = Conversation.create!(low_user_id: low_user.id, high_user_id: high_user.id)
    end    
  end
end
