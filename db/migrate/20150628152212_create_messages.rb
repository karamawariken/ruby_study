class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string  :content
      t.integer :sender_id
      t.integer :reciptient_id
      t.boolean :read

      t.timestamps
    end
  end
end
