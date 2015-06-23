class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body, :conversation_id, :user_id

  def message_time
    create_at.strftime("%m/%d/%y at%l:%M %p")
  end

  # 新規メッセージの通知メソッド
  # def notice_new_message(recipient_id)
  # end
end