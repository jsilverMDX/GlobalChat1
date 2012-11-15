class ChatMessage < ActiveRecord::Base
  attr_accessible :handle, :message


  def self.chat_log
  	@messages = ChatMessage.all
  	output_chat_messages(@messages)
  end

  def self.output_chat_messages(messages)
  	@log = ""
  	messages.each do |message|
  		@log += "#{message.handle}: #{message.message}\n"
  	end
    p @log
  	@log
  end
end
