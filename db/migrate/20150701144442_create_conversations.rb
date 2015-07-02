class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :low_user_id  , null: false
      t.integer :high_user_id , null: false

      t.timestamps
    end
    add_index :conversations, [:low_user_id, :high_user_id], :unique => true, :name => 'uses_pair_uniq_index'
    add_index :conversations, [:low_user_id], :name => 'index_conversations_on_low_user_id'
    add_index :conversations, [:high_user_id], :name => 'index_conversations_on_high_user_id'
  end
end
