class MessagesController < ApplicationController

  def index
    # @message = @conversation.messages.new
  end

  #会話の中身を見る
  def show

  end

  def new
    @message = @conversation.messages.new
  end

  #メッセージ作成
  def create
    raise params.inspect
    @message = @user.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  # private
  #   def message_params
  #
  #   end

end
