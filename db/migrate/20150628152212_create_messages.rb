class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :content, null: false
      t.integer :sender_id, null: false
      t.integer :reciptient_id, null: false

      t.timestamps
    end
  end
end
