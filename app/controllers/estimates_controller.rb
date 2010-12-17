class EstimatesController < ApplicationController
  before_filter :detect_user, :only => [:reveal, :create]

  # Security note:
  # #detect_story checks to make sure that the user has access to this story in PT before modifying estimate.  All client
  # actions will raise exception if access to this resource on PT is denied, so this provides some level of
  # security against clients who may try to set estimates on another users' game.  Note that we don't do anything
  # about users who try to grab the json results of other users' estimation sessions, as this would be too much
  # overhead on requests that are used in polling.
  before_filter :detect_story, :only => [:reveal, :create]

  def index
    result = if game = Game.first(:conditions => { :tracker_story_id => params[:story_id] })
      { :revealed => game.revealed, :estimates => game.estimates, :tracker_estimate => game.tracker_estimate }
    else
      { :revealed => false, :estimates => {}, :tracker_estimate => nil }
    end

    render :json => result
  end

  def reveal
    game = Game.find_by_tracker_story_id(params[:story_id])

    if params[:revealed] == 'true'
      game.update_attributes(:revealed => params[:revealed], :revealed_last_changed_by => @user.username)
    else
      game.update_attributes(:estimates => {}, :revealed => false, :revealed_last_changed_by => @user.username)
    end

    head 200 
  end

  # Creates or updates an estimate thrown by a user.
  def create
    if game = Game.first(:conditions => { :tracker_story_id   => params[:story_id] })
      game.estimates = ( game.estimates || { } ).merge(@user.username => params[:estimate])
      game.save!
    else
      Game.create(:tracker_story_id => params[:story_id], :estimates => { @user.username => params[:estimate] } )
    end

    flash[:success] = "Estimate registered"

    redirect_to project_story_path(params[:project_id], params[:story_id])
  end
end