class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :low_user_id  , null: false
      t.integer :high_user_id , null: false

      t.timestamps
    end
    add_index :conversations, [:low_user_id, :high_user_id], :unique => true, :name => 'uses_pair_uniq_index'
  end
end
