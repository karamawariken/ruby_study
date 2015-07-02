class AddConversationIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :conversation_id, :integer, null: false
  end
end
