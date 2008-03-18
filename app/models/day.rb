class Day
  ITERATION_LENGTH = 5
  attr_accessor :timestamp, :points_to_do, :points_done_all, :points_done_today, 
    :speed_last_days, :speed_iteration, :speed_iteration_cumulated,
    :speed_overall, :points_undone_all, :points_undone_all_from_top
  
  def initialize(timestamp, previous_day)
    @timestamp = timestamp
    @points_to_do = previous_day ? previous_day.points_to_do : 0
    @points_done_all  = previous_day ? previous_day.points_done_all : 0
    @points_undone_all = previous_day ? previous_day.points_undone_all : 0
    @points_done_today = 0
    @speed_last_days = 0
    @speed_iteration = 0
    @speed_iteration_cumulated = 0
    @speed_overall = 0
    @points_undone_all_from_top = 0
  end
  
  def self.days_for_project(project)
    days = []
    events = Event.find(:all, :conditions => ['events.project_id = ? AND events.card_id IS NOT NULL', project.id], 
      :order => 'events.created_at ASC', :include => :card)

    events.each do |event|

      unless day = days.select {|d| d.timestamp.same_date_as?(event.created_at)}.first
        previous_day = days.last
        day = Day.new(event.created_at, previous_day)
        days << day
      end

      if event.card_estimated?
        add_points = event.to.to_i - (event.from ? event.from.to_i : 0)
        day.points_to_do  += add_points
      end
      if event.card_finished?
        day.points_done_all   += event.card.effort
        day.points_done_today  += event.card.effort
      end
    end

    unless days.empty?
      days = calculate_points_undone_all_from_top(days)
      days = calculate_points_undone_all(days)
      days = calculate_speed_overall(days)
      days = calculate_speed_last_days(days)
      days = calculate_speed_iteration(days)
      days = calculate_speed_iteration_cumulated(days)
    end
    days
  end
  
  private
    def self.calculate_points_undone_all_from_top(days)
      days.first.points_undone_all_from_top = days.last.points_to_do.to_f-days.first.points_done_today
      (1..(days.size-1)).each do |i|
        days[i].points_undone_all_from_top = days[i-1].points_undone_all_from_top - days[i].points_done_today
      end
      days
    end
    def self.calculate_points_undone_all(days)
      days.each do |day|
        day.points_undone_all = day.points_to_do - day.points_done_all
      end
      days
    end
    def self.calculate_speed_overall(days)
      days.each_with_index do |day,i|
        day.speed_overall = (day.points_done_all.to_f / (i+1)).round(2)
      end
      days
    end
    def self.calculate_speed_last_days(days)
      days.each do |day|
        i = days.index(day)
        left_i = (i-ITERATION_LENGTH+1) < 0 ? 0 : (i-ITERATION_LENGTH+1)
        days_before = days.slice(left_i, ITERATION_LENGTH)
        day.speed_last_days = days_before.inject(0) {|sum,d| sum += d.points_done_today}.to_f / ITERATION_LENGTH
      end
      days
    end
    def self.calculate_speed_iteration(days)
      days.each_slice(ITERATION_LENGTH) do |idays|
        points_done_up_to_now = 0
        idays.each_with_index do |d,i|
          points_done_up_to_now += d.points_done_today
          d.speed_iteration = (points_done_up_to_now.to_f / (i+1)).round(2)
        end
        idays.each do |d|
          d.speed_iteration = idays.last.speed_iteration
        end
      end
      days
    end
    def self.calculate_speed_iteration_cumulated(days)
      days.each_slice(ITERATION_LENGTH) do |idays|
        index_of_last_day_of_previous_iteration = days.index(idays.first)-1
        cumulated_average_of_previous_iteration = index_of_last_day_of_previous_iteration < 0 ?
          0 : days[index_of_last_day_of_previous_iteration].speed_iteration_cumulated
        idays.each_with_index do |d,i| 
          d.speed_iteration_cumulated = cumulated_average_of_previous_iteration + 
            ((i+1)*d.speed_iteration)
        end
      end
      days
    end
  
end
