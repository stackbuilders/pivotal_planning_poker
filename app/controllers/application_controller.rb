class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def detect_user
    @user = PivotalPlanningPoker::User.new( :token => session[:tracker_token],
                                            :user_id => session[:user_id],
                                            :username => session[:username] )
  end

  def detect_story
    @story = PivotalPlanningPoker::Story.find(params[:project_id], params[:story_id], @user.token)
  end

  def detect_project
    @project = PivotalPlanningPoker::Project.find(params[:project_id], @user.token)
  end

end
