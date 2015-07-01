class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :low_user_id
      t.integer :high_user_id

      t.timestamps
    end
  end
end
