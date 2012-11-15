require 'spec_helper'

describe "ChatMessage" do


  before :each do
    ChatMessage.create!(:handle => "jsilver", :message => "Welcome to GlobalChat!")
    ChatMessage.create!(:handle => "jsilver", :message => "Welcome to GlobalChat!")
    ChatMessage.create!(:handle => "jsilver", :message => "Welcome to GlobalChat!")

  end


  it "should exist" do

    ChatMessage.all.count.should > 0
  end

  it "should be able to display a list of messages if necessary" do
  	ChatMessage.chat_log.should == <<-HEREDOC
jsilver: Welcome to GlobalChat!
jsilver: Welcome to GlobalChat!
jsilver: Welcome to GlobalChat!
  	HEREDOC
  end

  after do
  	ChatMessage.destroy_all
  end


end
