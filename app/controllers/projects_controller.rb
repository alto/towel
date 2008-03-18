class ProjectsController < ApplicationController
  include Ziya
  
  before_filter :login_required, :except => [:show]
  before_filter :load_project, :only => [:show]

  def show
    @cards = @project.cards
    @days = Day.days_for_project(@project)
    respond_to do |format|
      format.html
      format.up_chart do
        if last_day = @days.last
          render :text => build_up_chart(@days)
        else
          render :nothing => true
        end
      end
      format.down_chart do
        if last_day = @days.last
          render :text => burn_down_chart(@days)
        else
          render :nothing => true
        end
      end
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.user = current_user
    @project.save!
    redirect_to project_path(@project)
  rescue
    render :action => 'new'
  end

  private
    def load_project
      @project = Project.find_by_url_slug(params[:id]) or raise ActiveRecord::RecordNotFound
    end
    
    def build_up_chart(days)
      chart = Ziya::Charts::Line.new
      points_to_reach = days.last.points_to_do
      points_reached = days.last.points_done_all
      # last_speed = days.last.speed_overall
      last_speed = days.last.speed_iteration
      last_speed = days[days.size-2].speed_iteration if last_speed == 0.0
      num_days_to_reach_points = last_speed > 0 ? ((points_to_reach - points_reached) / last_speed).round : 1000
      speed_points = days.map(&:speed_iteration_cumulated)
      (days.size..(num_days_to_reach_points+days.size)).each do |i|
        speed_points << (speed_points.last + last_speed)
      end

      xlabels = (1..speed_points.size).to_a
      xlabels.each_with_index {|x,i| xlabels[i] = ((i+1)%Day::ITERATION_LENGTH == 0) ? xlabels[i] : '' }
      chart.add(:series, 'xlabels', xlabels)

      chart.add(:series, 'speed_points', speed_points)

      # chart.add(:series, 'points_done_today', days.map(&:points_done_today))
      chart.add(:series, 'points_done_all', days.map(&:points_done_all))
      # chart.add(:series, 'speed_overall', days.map(&:speed_overall))
      # chart.add(:series, 'speed_last_days', days.map(&:speed_last_days))
      # chart.add(:series, 'speed_iteration', days.map(&:speed_iteration))

      points_to_do = days.map(&:points_to_do)
      last_points_to_do = points_to_do.last
      (days.size..(num_days_to_reach_points+days.size)).each do |i|
        points_to_do << last_points_to_do
      end
      
      chart.add(:series, 'points_to_do', points_to_do)
      chart.add(:series, 'speed_iteration_cumulated', days.map(&:speed_iteration_cumulated))

      chart.add(:theme, 'towel')
      chart
    end
    
    def burn_down_chart(days)
      chart = Ziya::Charts::Line.new

      points_to_reach = days.last.points_to_do
      points_reached  = days.last.points_done_all
      last_speed = days.last.speed_iteration
      last_speed = days[days.size-2].speed_iteration if last_speed == 0.0
      num_days_to_reach_points = last_speed > 0 ? ((points_to_reach - points_reached) / last_speed).round : 1000

      speed_points = days.map(&:points_undone_all)
      (days.size..(num_days_to_reach_points+days.size)).each do |i|
        speed_points << (speed_points.last - last_speed)
      end

      xlabels = (1..speed_points.size).to_a
      xlabels.each_with_index {|x,i| xlabels[i] = ((i+1)%Day::ITERATION_LENGTH == 0) ? xlabels[i] : '' }
      chart.add(:series, 'xlabels', xlabels)

      chart.add(:series, 'speed_points', speed_points)
      chart.add(:series, 'points_undone_all', days.map(&:points_undone_all))
      # chart.add(:series, 'points_to_do', days.map(&:points_to_do))
      chart.add(:series, 'points_undone_all_from_top', days.map(&:points_undone_all_from_top))

      chart.add(:theme, 'towel')
      chart
    end
    
end
