class AddReadToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :read, :boolean, null: false, default: false
  end
end
