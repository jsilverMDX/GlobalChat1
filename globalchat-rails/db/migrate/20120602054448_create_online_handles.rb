class CreateOnlineHandles < ActiveRecord::Migration
  def change
    create_table :online_handles do |t|
      t.string :handle
      t.string :chat_token
      t.timestamp :last_poll
      t.timestamps
    end
  end
end
