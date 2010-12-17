require 'spec_helper'

describe EstimatesController do
  before do
    controller.stub!(:detect_story)
  end
  
  describe "GET #index" do
    it "should return a json hash describing the requested game if the game exists" do
      game = Factory(:game)
      get :index, :story_id => game.tracker_story_id, :project_id => '33'
      ActiveSupport::JSON.decode(response.body).should == { 'revealed' => game.revealed, 'estimates' => game.estimates, 'tracker_estimate' => game.tracker_estimate }
    end

    it "should return a hash describing an empty game if one is not found in the database" do
      get :index, :story_id => '100', :project_id => '33'
      ActiveSupport::JSON.decode(response.body).should == { 'revealed' => false, 'estimates' => {}, 'tracker_estimate' => nil }
    end
  end

  describe "PUT #reveal" do
    it "should change the revealed status of the game if params['revealed'] is true and set the revealed_last_changed_by attribute" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      game = Factory(:game, :revealed => false, :revealed_last_changed_by => nil)
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)
      put :reveal, :revealed => 'true', :story_id => game.tracker_story_id, :project_id => 'someid'

      game.reload
      game.revealed.should be_true
      game.revealed_last_changed_by.should == user.username
    end

    it "should set the revealed status of the game to false and set the revealed_last_changed_by attribute if the revealed param is not true" do
      game = Factory(:game, :revealed => false, :revealed_last_changed_by => nil)
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      put :reveal, :revealed => 'false', :story_id => game.tracker_story_id, :project_id => 'someid'

      game.reload
      game.revealed.should be_false
      game.revealed_last_changed_by.should == user.username
    end

    it "should verify access to this story before it is estimated" do
      game = Factory(:game, :revealed => false, :revealed_last_changed_by => nil)
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      controller.should_receive(:detect_story)
      put :reveal, :revealed => 'false', :story_id => game.tracker_story_id, :project_id => 'someid'
    end
  end

  describe "POST #create" do
    it "should create an estimate for the user if it doesn't already exist" do
      game = Factory(:game)
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      post :create, :story_id => game.tracker_story_id, :estimate => 2, :project_id => '23'
      game.reload.estimates[user.username].should == 2
    end

    it "should should update an estimate for a user if the user has already thrown" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      game = Factory(:game, :estimates => {user.username => 2})
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      post :create, :story_id => game.tracker_story_id, :estimate => 3, :project_id => '23'
      game.reload
      game.estimates[user.username].should == 3
    end

    it "should verify access to this story on tracker" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      game = Factory(:game, :estimates => {user.username => 2})
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)
      controller.should_receive(:detect_story)

      post :create, :story_id => game.tracker_story_id, :estimate => 3, :project_id => '23'
    end
  end
end