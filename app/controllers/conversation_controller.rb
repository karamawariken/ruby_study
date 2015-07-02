class ConversationController < ApplicationController
  before_action :signed_in_user

  def index
    @conversations = Conversation.current_user_conversation(current_user).paginate(page: params[:page], :per_page => 10)
  end


  #フォーム作って会話の相手を@で出してメッセージと会話を作成する
  def create
    @message = create_conversation_and_message(message_params)
    if @message.save
      flash[:success] = "success"
      redirect_to conversation_index_path
    else
      flash[:error] = "error"
      content_fault = "d @"
      @message = Message.new(content: content_fault, sender_id: current_user, read: false)
      render 'new'
    end
  end

  def new
    content_fault = "d @"
    @message = Message.new(content: content_fault, sender_id: current_user, read: false)
  end


  private

  def message_params
    params.require(:message).permit(:content, :sender_id)
  end

  #フォームから相手idが来るので会話があったら更新し、無い場合は作成
  #他との整合性をとるため必ず "d @nickname message"にさせる
  def create_conversation_and_message(message)
    if reciptient_user = message[:content].match(/^d[\s\u3000]+@(\w+)[\s\u3000]*(\S*)/i)
      if reciptient_user[2].present? && reciptient_user = User.find_by(nickname: reciptient_user[1])
        @conversation = find_conversation(current_user,reciptient_user)
        @message = Message.new(sender_id: current_user.id,reciptient_id: reciptient_user.id ,content: message[:content],read: false, conversation_id: @conversation.id)
      else
        @message = Message.new()
      end
    else
      @message = Message.new()
    end
  end

end
