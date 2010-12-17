class StoriesController < ApplicationController
  before_filter :detect_user
  before_filter :detect_project

  def show
    @story = PivotalPlanningPoker::Story.find(params[:project_id], params[:id], @user.token)
    create_or_update_game(@story.story_id, @story.estimate)
  end

  def update
    tracker_story = PivotalPlanningPoker::Story.find(params[:project_id], params[:id], @user.token)
    tracker_story.update_estimate(params['estimate'], @user.token)

    create_or_update_game(tracker_story.story_id, tracker_story.estimate)

    flash[:success] = "Story estimate updated"
    redirect_to project_story_path(@project.project_id, tracker_story.story_id)
  end

  private

  def create_or_update_game(tracker_story_id, tracker_estimate)
    if game = Game.first(:conditions => { :tracker_story_id => tracker_story_id })
      game.update_attribute(:tracker_estimate, tracker_estimate)
    else
      Game.create(:tracker_story_id => tracker_story_id, :tracker_estimate => tracker_estimate, :estimates => {})
    end
  end
end