class ConversationsController < ApplicationController
  before_action :signed_in_user

  def index
    @conversations = Conversation.current_user_conversation(current_user).paginate(page: params[:page], :per_page => 10)
  end


  #フォーム作って会話の相手を@で出してメッセージと会話を作成する
  def create
    @message = create_message(message_params)
    if @message.present?
      if @message.save
        flash[:success] = "success"
        redirect_to message_path(@message.reciptient_user)
      else
        flash[:error] = "error"
        content_fault = "d @"
        @message = Message.new(content: content_fault, sender_id: current_user, read: false)
        render 'new'
      end
    end
  end

  def new
    # content_fault = "d @"
    # raise params.inspect
    @message = Message.new(sender_id: current_user, read: false)
  end


  private

  def message_params
    params.require(:message).permit(:content, :sender_id)
  end

  #フォームから相手idが来るので会話があったら更新し、無い場合は作成
  #他との整合性をとるため必ず "d @nickname message"にさせる
  def create_message(message)
    if split_content = message[:content].match(/^d[\s\u3000]+@(\w+)[\s\u3000]*(\S*)/i)
      create_conversation_and_message(message, split_content)
    end
  end

end
