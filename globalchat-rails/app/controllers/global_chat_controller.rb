
class GlobalChatController < ApplicationController

  before_filter :identify_user, :except => [:signOn, :root]

  def root
    ping_nexus
    render :nothing => true
  end

  def signOn
    ping_nexus
    if params[:handle] == ""
      render :text => ""
    else
      begin
        @you = OnlineHandle.create!(:handle => params[:handle])
      rescue ActiveRecord::RecordInvalid
        @you = OnlineHandle.create!(:handle => "#{params[:handle]}#{rand(1000)}")
      end
      render :text => "#{@you.chat_token}:#{@you.handle}"
    end
  end

  def getChatLog
    @you.update_attribute(:last_poll, Time.now)
    render :text => ChatMessage.chat_log
  end

  def getMessages
    @log = @you.new_messages
    @you.update_attribute(:last_poll, Time.now)
    render :text => @log
  end

  def postAChatMessage
    ChatMessage.create!(:message => params[:message], :handle => @you.handle)
    render :nothing => true
  end

  def getOnlineHandles
    render :text => OnlineHandle.online_handles
  end

  def signOff
    OnlineHandle.find_by_chat_token(@you.chat_token).destroy
    render :nothing => true
  end

  private

  def identify_user
    @you = OnlineHandle.find_by_chat_token(params[:chat_token])
  end
end
