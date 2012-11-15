require 'spec_helper'

describe GlobalChatController do

  before do
    get 'signOn', :handle => "jsilver"
    @chat_token = response.body.split(":")[0]
  end

  describe "GET 'signOn'" do
    it "creates an online handle for you" do

      response.should be_success
      response.body.split(":")[0].should == OnlineHandle.find_by_handle("jsilver").chat_token
      
    end

    it "should create a handle for you with chat token" do

      OnlineHandle.find_by_handle("jsilver").nil?.should == false
      OnlineHandle.find_by_handle("jsilver").chat_token.nil?.should == false
    end

    it "cant sign on a blank name" do
      get 'signOn', :handle => ""
      response.body.should == ""
    end

  end

  describe "GET 'getChatLog'" do
    it "returns a chat log" do

      ChatMessage.create!(:handle => "jsilver", :message => "Welcome to GlobalChat!")
      ChatMessage.create!(:handle => "jsilver", :message => "Welcome to GlobalChat!")
      ChatMessage.create!(:handle => "jsilver", :message => "Welcome to GlobalChat!")
      get 'getChatLog', :chat_token => @chat_token
      response.should be_success
      response.body.should == ChatMessage.chat_log
    end

    it "should have set last_poll" do
      get 'getChatLog', :chat_token => @chat_token
      OnlineHandle.find_by_handle("jsilver").last_poll.to_i.should == Time.now.to_i
    end
  end

  describe "GET 'getMessages'" do
    it "returns http success" do
      get 'getMessages', :chat_token => @chat_token
      response.should be_success
    end

    it "should return all the messages since last poll" do
      get 'getChatLog', :chat_token => @chat_token
      cm = ChatMessage.new(:handle => "jsilver", :message => "whatsup")

      cm.created_at = Time.now + 10.seconds
      cm.save
      get 'getMessages', :chat_token => @chat_token
      response.body.should == "jsilver: whatsup\n"
    end

    it "should set the last poll time" do
      get 'getMessages', :chat_token => @chat_token
      OnlineHandle.find_by_handle("jsilver").last_poll.to_i.should == Time.now.to_i
    end

  end

  describe "POST 'postAChatMessage'" do
    it "returns http success" do
      post 'postAChatMessage', :message => "I love chatting!", :chat_token => @chat_token
      ChatMessage.find_by_message("I love chatting!").nil?.should == false
      response.should be_success
    end
  end

  describe "GET 'getOnlineHandles'" do
    it "returns http success" do
      get 'getOnlineHandles', :chat_token => @chat_token
      response.should be_success
      response.body.should == "jsilver\n"
    end
  end

  describe "GET 'signOff'" do
    it "returns http success" do
      get 'signOff', :chat_token => @chat_token
      response.should be_success
      OnlineHandle.find_by_handle("jsilver").should == nil
    end
  end

end
