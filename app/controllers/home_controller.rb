class HomeController < ApplicationController

  def index
    @user = PivotalPlanningPoker::User.new(params)
    render "user_sessions/new"
  end
end