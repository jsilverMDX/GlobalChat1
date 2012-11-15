class AppDelegate
  #include RMSettable

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    #rm_settable App.settable    
    true
  end
  
  def setWindow(new_window)
     @window = new_window
  end

  def window
     @window
  end  
  
end