class ProjectsController < ApplicationController
  before_filter :detect_user

  def index
    @projects = @user.projects
  end

  def show
    @project = PivotalPlanningPoker::Project.find(params[:id], @user.token)
    @stories = PivotalPlanningPoker::Story.for_project(@project, @user.token)
  end
end