require 'spec_helper'

describe PivotalPlanningPoker::User do
  describe "initialization" do
    it "should initialize attributes from a hash" do
      user = PivotalPlanningPoker::User.new(:username => 'Joe', :password => 'foo', :token => '34334', :user_id => 222)
      user.username.should == 'Joe'
      user.password.should == 'foo'
      user.token.should == '34334'
      user.user_id.should == 222
    end
  end

  describe "#projects" do
    it "should return the projects for the user" do
      user = PivotalPlanningPoker::User.new
      PivotalPlanningPoker::Project.should_receive(:for_user).with(user).and_return([:foo])
      user.projects.should == [:foo]
    end
  end

  describe "#authenticate!" do
    it "should call curl with headers containing the username and password" do
      user = PivotalPlanningPoker::User.new(:username => 'joe', :password => 'mypass', :token => '34334', :user_id => 222)

      curl_config = mock('curl_config')
      curl_config.should_receive(:userpwd=).with('joe:mypass')

      curl_easy = mock('curl_easy', :body_str => 'auth response')

      Curl::Easy.should_receive(:perform).and_yield(curl_config).and_return(curl_easy)
      user.authenticate!
    end

    it "should return true if the response does not include 'Access is denied'" do
      user = PivotalPlanningPoker::User.new(:username => 'joe', :password => 'mypass', :token => '34334', :user_id => 222)

      curl_config = mock('curl_config')
      curl_config.should_receive(:userpwd=).with('joe:mypass')

      curl_easy = mock('curl_easy', :body_str => 'Access denied')

      Curl::Easy.should_receive(:perform).and_yield(curl_config).and_return(curl_easy)
      user.authenticate!.should be_false
    end

    it "should return true if the response does not include 'Access is denied'" do
      user = PivotalPlanningPoker::User.new(:username => 'joe', :password => 'mypass', :token => '34334', :user_id => 222)

      curl_config = mock('curl_config')
      curl_config.should_receive(:userpwd=).with('joe:mypass')

      curl_easy = mock('curl_easy', :body_str => '<user><guid>foo</guid><id></id></user>')

      Curl::Easy.should_receive(:perform).and_yield(curl_config).and_return(curl_easy)
      user.authenticate!.should be_true
    end
  end
end