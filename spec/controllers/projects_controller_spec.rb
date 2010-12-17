require 'spec_helper'

describe ProjectsController do
  describe "GET #index" do
    it "should assign the users' projects to @projects" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank')
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)
      
      projects = [PivotalPlanningPoker::Project.new(Nokogiri::XML('<a/>'))]
      user.should_receive(:projects).and_return(projects)

      get :index
      assigns[:projects].should == projects
    end
  end

  describe "GET #show" do
    it "should assign the @project and stories" do
      user = PivotalPlanningPoker::User.new(:username => 'Frank', :token => 42)
      PivotalPlanningPoker::User.should_receive(:new).and_return(user)

      project = PivotalPlanningPoker::Project.new(Nokogiri::XML('<a/>'))
      PivotalPlanningPoker::Project.should_receive(:find).with(22, user.token).and_return(project)

      story = PivotalPlanningPoker::Story.new(Nokogiri::XML('<a/>'))
      PivotalPlanningPoker::Story.should_receive(:for_project).with(project, user.token).and_return([story])

      get :show, :id => 22
      
      assigns[:project].should == project
      assigns[:stories].should == [story]
    end
  end
end