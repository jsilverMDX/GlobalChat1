class OnlineHandle < ActiveRecord::Base
  attr_accessible :handle, :last_poll

  before_create :make_chat_token

  validates_uniqueness_of :chat_token, :handle

  def make_chat_token
  	self.chat_token = rand(36**8).to_s(36)
  end

  def new_messages
  	@messages = ChatMessage.where(['chat_messages.created_at > ?', self.last_poll])
  	ChatMessage.output_chat_messages(@messages)
  end


  def self.online_handles
    OnlineHandle.where(['last_poll < ?', Time.now - 1.minute]).destroy_all
  	handles = OnlineHandle.where(['last_poll > ?', Time.now - 10.seconds])
  	@out = ""
  	handles.each do |handle|
  		@out += "#{handle.handle}\n"
  	end
  	@out
  end

end
