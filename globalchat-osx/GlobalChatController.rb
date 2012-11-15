require 'net/http'
require 'uri'

class GlobalChatController

  QUEUE = Dispatch::Queue.new('com.mdx.globalchat')

  attr_accessor :chat_token, :chat_buffer, :nicks, :handle, :handle_text_field, :connect_button, :sign_in_window, :chat_window, :chat_window_text, :chat_message, :nicks_table, :application, :scroll_view, :last_scroll_view_height, :host


  def initialize
    $gcc = self
  end

  def quit(sender)
    sign_out
    @application.terminate(self)
  end

  def tableView(view, objectValueForTableColumn:column, row:index)
    self.nicks[index]
  end

  def numberOfRowsInTableView(view)
    self.nicks.size
  end

  def sendMessage(sender)
    @message = sender.stringValue
    NSLog(@message)
    if @message != ""
      post_message(@message)
      @chat_message.setStringValue('')
    end
  end

  def signIn(sender)
    sign_on(@handle_text_field.stringValue)
    @sign_in_window.close

    get_log
    sleep 0.1

    # loops
    QUEUE.async do
      get_handles
      poll_server
    end


    NSTimer.scheduledTimerWithTimeInterval(0.1,
                                           target:$gcc,
                                           selector:"update_chat_views",
                                           userInfo:nil,
                                           repeats:true)
    NSTimer.scheduledTimerWithTimeInterval(1,
                                           target:$gcc,
                                           selector:"scroll_the_scroll_view_down",
                                           userInfo:nil,
                                           repeats:false)

    @chat_window.makeKeyAndOrderFront(nil)

      #@chat_window_text.dataDetectorTypes = UIDataDetectorTypeAll
  end

  def poll_server
    get_messages
    QUEUE.async do
      sleep 0.1
      poll_server
    end
  end

  def scroll_the_scroll_view_down
    y = self.scroll_view.documentView.frame.size.height - self.scroll_view.contentSize.height #+ 10
    #unless y == @last_y
    #NSLog("y: #{y}")
    self.scroll_view.contentView.scrollToPoint(NSMakePoint(0, y))
    #@last_y = y
    #end
  end

  def update_chat_views
    if !@last_buffer || @last_buffer != self.chat_buffer
      @chat_window_text.setString(NSString.stringWithUTF8String(self.chat_buffer))
      @last_buffer ||= self.chat_buffer
    end
  end

  def sign_on(handle)
    puts self.host
    resp = Net::HTTP.get(self.host, "/signOn?handle=#{handle}")
    ct = resp.split(":")[0]
    nm = resp.split(":")[1]
    self.chat_token = ct
    self.handle = nm
  end

  def post_message(message)
    msg_uri = URI.parse("http://#{self.host}/postAChatMessage") 
    query = {:chat_token => @chat_token, :message => message}
    msg_uri.query = URI.encode_www_form( query )
    Net::HTTP.get(msg_uri)
  end

  def get_log
    self.chat_buffer = Net::HTTP.get(self.host, "/getChatLog?chat_token=#{self.chat_token}")
  end

  def get_messages
    msg = Net::HTTP.get(self.host, "/getMessages?chat_token=#{self.chat_token}")
    unless msg == ""
      self.chat_buffer += msg
      scroll_the_scroll_view_down
    end
  end

  def get_handles
    self.nicks = Net::HTTP.get(self.host, "/getOnlineHandles?chat_token=#{self.chat_token}").split("\n")
    if !@last_nicks_list || @last_nicks_list.sort! != self.nicks.sort!
      @nicks_table.dataSource = self
      @nicks_table.reloadData
      @last_nicks_list = self.nicks
    end

    QUEUE.async do
      sleep 0.1
      get_handles
    end
  end

  def sign_out
    Net::HTTP.get(self.host, "/signOff?chat_token=#{self.chat_token}")
  end

end
