require File.dirname(__FILE__) + '/../spec_helper'

describe Day, "days_for_project for a long running project" do
  before do
    @project = create_project
    @project.stub!(:every_day_project?).and_return(false)
    
    Time.advance_by_days  = -2
    @card_finished_adhoc  = create_card(:project => @project, :effort => 2)
    @card_finished_adhoc.update_attribute(:finished_at, Time.now)
    @card_finished        = create_card(:project => @project, :effort => 3)
    @card_started         = create_card(:project => @project, :effort => 2)
    @card_reestimated     = create_card(:project => @project, :effort => 1)
    
    Time.advance_by_days  = -1
    @card_estimated       = create_card(:project => @project, :effort => 1)
    @card_reestimated.update_attribute(:effort,4)
    @card_finished.update_attribute(:started_at, Time.now)
    @card_started.update_attribute(:started_at, Time.now)
    
    Time.advance_by_days  = 0
    @card_finished.update_attribute(:finished_at, Time.now)
    @card_reestimated.update_attribute(:effort,5)
  end
  it "should deliver days" do
    days = Day.days_for_project(@project)
    days.size.should eql(3)
    days[0].timestamp.same_time_as?(2.days.ago).should be_true
    days[1].timestamp.same_time_as?(1.day.ago).should be_true
    days[2].timestamp.same_time_as?(Time.now).should be_true
  end
  it "should deliver points not yet done" do
    days = Day.days_for_project(@project)
    days[0].points_undone_all.should eql(6)
    days[1].points_undone_all.should eql(10)
    days[2].points_undone_all.should eql(8)
  end
  it "should deliver points not yet done, from the top" do
    days = Day.days_for_project(@project)
    days[0].points_undone_all_from_top.should eql(11.0)
    days[1].points_undone_all_from_top.should eql(11.0)
    days[2].points_undone_all_from_top.should eql(8.0)
  end
  it "should deliver overall speed" do
    days = Day.days_for_project(@project)
    days[0].speed_overall.should eql(2.0)
    days[1].speed_overall.should eql(1.0)
    days[2].speed_overall.should eql(1.67)
  end
  it "should deliver points done that day" do
    days = Day.days_for_project(@project)
    days[0].points_done_today.should eql(2)
    days[1].points_done_today.should eql(0)
    days[2].points_done_today.should eql(3)
  end
  it "should deliver speed of that iteration" do
    days = Day.days_for_project(@project)
    days[0].speed_iteration.should eql(1.67)
    days[1].speed_iteration.should eql(1.67)
    days[2].speed_iteration.should eql(1.67)
  end
  it "should deliver cumulated speed of that iteration" do
    days = Day.days_for_project(@project)
    days[0].speed_iteration_cumulated.should eql(1.67)
    days[1].speed_iteration_cumulated.should eql(3.34)
    days[2].speed_iteration_cumulated.should eql(5.01)
  end
  it "should deliver points to do per day" do
    days = Day.days_for_project(@project)
    days[0].points_to_do.should eql(8)
    days[1].points_to_do.should eql(12)
    days[2].points_to_do.should eql(13)
  end
  it "should deliver overall points done" do
    days = Day.days_for_project(@project)
    days[0].points_done_all.should eql(2)
    days[1].points_done_all.should eql(2)
    days[2].points_done_all.should eql(5)
  end
end

describe Day, "days_for_project for an every day project" do
  before do
    @project = create_project
    @project.stub!(:every_day_project?).and_return(true)
    
    offset =  3 if Time.now.wday == 0
    offset =  2 if Time.now.wday == 1
    offset =  1 if Time.now.wday == 2
    offset =  0 if Time.now.wday == 3
    offset = -1 if Time.now.wday == 4
    offset = -2 if Time.now.wday == 5
    offset = -3 if Time.now.wday == 6
    # make sure we start on a Wednesday
    offset = 3-Time.now.wday
    
    Time.advance_by_days  = offset-2
    @card_finished_adhoc  = create_card(:project => @project, :effort => 2)
    @card_finished_adhoc.update_attribute(:finished_at, Time.now)
    @card_finished        = create_card(:project => @project, :effort => 3)
    @card_started         = create_card(:project => @project, :effort => 2)
    @card_reestimated     = create_card(:project => @project, :effort => 1)
    
    Time.advance_by_days  = offset-1
    @card_estimated       = create_card(:project => @project, :effort => 1)
    @card_reestimated.update_attribute(:effort,4)
    @card_finished.update_attribute(:started_at, Time.now)
    @card_started.update_attribute(:started_at, Time.now)
    
    Time.advance_by_days  = offset
    @card_finished.update_attribute(:finished_at, Time.now)
    @card_reestimated.update_attribute(:effort,5)
  end
  after do
    Time.advance_by_days  = 0
  end
  it "should deliver days" do
    days = Day.days_for_project(@project)
    days.size.should eql(5)
    days[0].timestamp.same_time_as?(2.days.ago).should be_true
    days[1].timestamp.same_time_as?(1.day.ago).should be_true
    days[2].timestamp.same_time_as?(Time.now).should be_true
  end
  it "should deliver points not yet done" do
    days = Day.days_for_project(@project)
    days[0].points_undone_all.should eql(6)
    days[1].points_undone_all.should eql(10)
    days[2].points_undone_all.should eql(8)
  end
  it "should deliver points not yet done, from the top" do
    days = Day.days_for_project(@project)
    days[0].points_undone_all_from_top.should eql(11.0)
    days[1].points_undone_all_from_top.should eql(11.0)
    days[2].points_undone_all_from_top.should eql(8.0)
  end
  it "should deliver overall speed" do
    days = Day.days_for_project(@project)
    days[0].speed_overall.should eql(2.0)
    days[1].speed_overall.should eql(1.0)
    days[2].speed_overall.should eql(1.67)
  end
  it "should deliver points done that day" do
    days = Day.days_for_project(@project)
    days[0].points_done_today.should eql(2)
    days[1].points_done_today.should eql(0)
    days[2].points_done_today.should eql(3)
  end
  it "should deliver speed of that iteration" do
    days = Day.days_for_project(@project)
    days[0].speed_iteration.should eql(1.0)
    days[1].speed_iteration.should eql(1.0)
    days[2].speed_iteration.should eql(1.0)
  end
  it "should deliver cumulated speed of that iteration" do
    days = Day.days_for_project(@project)
    days[0].speed_iteration_cumulated.should eql(1.0)
    days[1].speed_iteration_cumulated.should eql(2.0)
    days[2].speed_iteration_cumulated.should eql(3.0)
  end
  it "should deliver points to do per day" do
    days = Day.days_for_project(@project)
    days[0].points_to_do.should eql(8)
    days[1].points_to_do.should eql(12)
    days[2].points_to_do.should eql(13)
  end
  it "should deliver overall points done" do
    days = Day.days_for_project(@project)
    days[0].points_done_all.should eql(2)
    days[1].points_done_all.should eql(2)
    days[2].points_done_all.should eql(5)
  end
end

