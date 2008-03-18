class CardsController < ApplicationController

  before_filter :login_required
  before_filter :load_project
  before_filter :load_card, :only => [:show,:edit,:update,:destroy]

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(params[:card])
    @card.project = @project
    @card.save!
    redirect_to project_card_path(@project, @card)
  rescue
    render :action => 'new'
  end
  
  def edit
  end
  
  def update
    timestamp = params[:card][:timestamp].blank? ? Time.now : params[:card][:timestamp]
    if params["commit"] == 'start'
      @card.update_attributes(:started_at => timestamp, :timestamp => timestamp)
      redirect_to project_path(@project)
    elsif params["commit"] == 'finish'
      @card.update_attributes(:finished_at => timestamp, :timestamp => timestamp)
      redirect_to project_path(@project)
    elsif @card.update_attributes(params[:card])
      redirect_to project_card_path(@project, @card)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @card.destroy
    redirect_to project_path(@project)
  end

  private
    def load_project
      @project = Project.find_by_url_slug(params[:project_id])
    end
    
    def load_card
      @card = @project.cards.find(params[:id])
    end
end
