class ChatViewController < UIViewController
  attr_accessor :handles_list
  attr_accessor :chat_buffer
  attr_accessor :chat_message
  

  def viewDidLoad
    $cvc = self
    NSTimer.scheduledTimerWithTimeInterval(0.2,
      target:self,
      selector:"refresh_chat_views",
      userInfo:nil,
    repeats:true)

  end

  def refresh_chat_views
    self.chat_buffer.text = $gcc.chat_buffer
    scroll_the_scroll_view_down
  end

  def scroll_the_scroll_view_down

    y = $cvc.chat_buffer.contentSize.height - $cvc.chat_buffer.frame.size.height
    if @last_scroll_view_height != y
      $cvc.chat_buffer.contentOffset = CGPoint.new(0, y);
      @last_scroll_view_height = y
    end

  end

  def sendMessage(sender)
    @message = self.chat_message.text
    NSLog(@message)
    if @message != ""
      $gcc.post_message(@message)
      @chat_message.text = ''
    end
  end
end
