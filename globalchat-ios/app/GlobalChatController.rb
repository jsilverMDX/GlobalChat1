class GlobalChatController

  HOST = "globalchatnet.herokuapp.com"
  QUEUE = Dispatch::Queue.new('com.mdx.globalchat')


  attr_accessor :chat_token, :chat_buffer, :nicks, :handle, :handle_text_field, :connect_button, :sign_in_window, :chat_window, :chat_window_text, :chat_message, :nicks_table, :application, :scroll_view, :last_scroll_view_height
  
  def initialize(name)

    sign_on(name)
  end

  def sign_on(name)
    BubbleWrap::HTTP.get("http://#{HOST}/signOn?handle=#{name}") do |response|
      resp = response.body.to_str
      ct = resp.split(":")[0]
      nm = resp.split(":")[1]
      self.chat_token = ct
      self.handle = nm
      NSLog("I logged in with #{self.handle} and token #{self.chat_token}")
      get_log
    end
  end

  def quit(sender)
    sign_out
    @application.terminate(self)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("GlobalChat")

    if not cell
      cell = UITableViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier:'GlobalChat'
    end

    cell.setText self.nicks[indexPath.row]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    self.nicks.size
  end

  def post_message(message)
    BubbleWrap::HTTP.get("http://#{HOST}/postAChatMessage?chat_token=#{self.chat_token}&message=#{message}") do |response|
      NSLog response.body.to_str
    end
  end

  def get_log
    BubbleWrap::HTTP.get("http://#{HOST}/getChatLog?chat_token=#{self.chat_token}") do |response|
      self.chat_buffer = response.body.to_str
      NSLog(self.chat_buffer)
      NSTimer.scheduledTimerWithTimeInterval(0.2,
                                             target:self,
                                             selector:"get_messages",
                                             userInfo:nil,
                                             repeats:true)
      get_handles
      NSTimer.scheduledTimerWithTimeInterval(5,
                                             target:self,
                                             selector:"get_handles",
                                             userInfo:nil,
                                             repeats:true)

    end
  end

  def get_messages

    BubbleWrap::HTTP.get("http://#{HOST}/getMessages?chat_token=#{self.chat_token}") do |response|
      unless response.body == nil
        msg = response.body.to_str
        if msg != ""
          # NSLog(msg)
          self.chat_buffer += msg
        end
      end
    end

  end

  def get_handles
    BubbleWrap::HTTP.get("http://#{HOST}/getOnlineHandles?chat_token=#{self.chat_token}") do |response|

      self.nicks = response.body.to_str.split("\n")
      if !@last_nicks || @last_nicks != self.nicks
        $cvc.handles_list.dataSource = self unless $cvc.handles_list.dataSource
        $cvc.handles_list.reloadData
        @last_nicks = self.nicks
      end
    end
  end

  def sign_out
    BubbleWrap::HTTP.get("http://#{HOST}/signOff?chat_token=#{self.chat_token}") do |response|
      NSLog response.body.to_str
    end
  end

end
