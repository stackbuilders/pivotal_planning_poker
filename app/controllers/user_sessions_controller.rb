class UserSessionsController < ApplicationController
  def create
    @user = PivotalPlanningPoker::User.new(params['user'])

    if @user.authenticate!
      session[:tracker_token] = @user.token
      session[:username] = @user.username
      session[:user_id] = @user.user_id

      flash[:success] = "Login successful"
      redirect_to projects_path
    else
      flash[:error] = "Login failed, please make sure you're using the correct login and pass for Pivotal Tracker and try again"
      redirect_to new_user_session_path
    end
  end

  def destroy
    reset_session
    redirect_to home_path
  end

  def new
    @user = PivotalPlanningPoker::User.new    
  end
end