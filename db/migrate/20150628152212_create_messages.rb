class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :content, null: false
      t.integer :sender_id, null: false
      t.integer :reciptient_id, null: false

      t.timestamps
    end
    add_index :messages, [:sender_id], :name => 'index_messages_on_sender_id'
    add_index :messages, [:reciptient_id], :name => 'index_messages_on_reciptient_id'
  end
end
