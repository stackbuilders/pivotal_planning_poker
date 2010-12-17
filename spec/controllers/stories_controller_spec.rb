require 'spec_helper'

describe StoriesController do
  describe "GET #show" do
    it "should create a new game with the attributes from the Tracker story if a game does not exist" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank', :token => 'token')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      story = PivotalPlanningPoker::Story.new(Nokogiri::XML('<story><estimate>2</estimate><id>3</id></story>').xpath('/story'))
      PivotalPlanningPoker::Project.stub(:find).and_return(PivotalPlanningPoker::Project.new(Nokogiri::XML('<project/>')))
      PivotalPlanningPoker::Story.stub(:find).with(2, 3, 'token').and_return(story)

      lambda {
        get :show, :project_id => 2, :id => 3
      }.should change(Game, :count).by(1)

      Game.last.tracker_estimate.should == 2
    end

    it "should update a game with the attributes from the Tracker story if the game already exists" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank', :token => 'token')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      game = Factory(:game, :tracker_estimate => 1)
      story = PivotalPlanningPoker::Story.new(Nokogiri::XML("<story><id>#{game.tracker_story_id}</id><estimate>2</estimate></story>").xpath('/story'))
      PivotalPlanningPoker::Story.stub(:find).with(2, 3, 'token').and_return(story)

      PivotalPlanningPoker::Project.stub(:find).and_return(PivotalPlanningPoker::Project.new(Nokogiri::XML('<project/>')))
      
      lambda {
        get :show, :project_id => 2, :id => 3
      }.should_not change(Game, :count)

      Game.last.tracker_estimate.should == 2
    end

  end

  describe "PUT #update" do
    it "should update the Tracker story estimate" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank', :token => 'foo')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      game = Factory(:game, :tracker_estimate => 1)
      story = PivotalPlanningPoker::Story.new(Nokogiri::XML("<story><id>#{game.tracker_story_id}</id><estimate>2</estimate></story>").xpath('/story'))
      PivotalPlanningPoker::Story.should_receive(:find).and_return(story)

      PivotalPlanningPoker::Project.should_receive(:find).and_return(mock('project', :project_id => 2))

      story.should_receive(:update_estimate).with(3, user.token)

      put :update, :id => 3, :project_id => 2, :estimate => 3
    end
  end
  
end