require 'spec_helper'

describe OnlineHandle do
  before do
    @jsilver = OnlineHandle.create(:handle => "jsilver")
  end


  it "should allow creation and deletion" do
    OnlineHandle.all.size.should > 0
  end

  it "should create for the user a chatToken" do
    @jsilver.chat_token.nil?.should == false
  end

  after do
    OnlineHandle.find_by_handle("jsilver").destroy
  end
end
