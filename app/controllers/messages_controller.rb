class MessagesController < ApplicationController

  #会話の中身を見る
  def show
    @messages = Messages.find_conversation(current_user.id,params[:id])
    if @messages.empty?
      flash[:error] = "メッセージ or 相手がいません"
      redirect_to users_path
    end
  end

  def new
    @message = @conversation.messages.new
  end

  #メッセージ作成
  def create
    @message = @user.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private

  def corrent_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end
