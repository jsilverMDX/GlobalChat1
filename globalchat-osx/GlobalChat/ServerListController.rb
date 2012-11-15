require 'net/http'

class ServerListController

    attr_accessor :server_list_hash, :names, :server_list_table, :server_list_window, :sign_in_window, :gcc

  def initialize
  	get_servers
  end

  def get_servers
    @server_list_hash = Net::HTTP.get('nexusnet.herokuapp.com', '/msl').
    split("\n").
    collect do |s|
      {:host => URI.parse(s.split("-!!!-")[3]).host, :name => s.split("-!!!-")[0]}
    end

    @names = Net::HTTP.get('nexusnet.herokuapp.com', '/msl').
    split("\n").
    collect do |s|
      s.split("-!!!-")[0]
    end
    
  end

  def tableView(view, objectValueForTableColumn:column, row:index)
    self.names[index]
  end

  def numberOfRowsInTableView(view)
    self.names.size
  end


  def refresh(sender)
  	get_servers
    @server_list_table.reloadData
  end

  def connect(sender)
      
      @gcc.host = @server_list_hash[self.server_list_table.selectedRow][:host]
      self.server_list_window.close
      self.sign_in_window.makeKeyAndOrderFront(nil)
  end


end
