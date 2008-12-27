require File.dirname(__FILE__) + '/../test_helper'

class DayTest < ActiveSupport::TestCase

  context "days_for_project for a long running project" do
    setup do
      @project = create_project
      @project.stubs(:every_day_project?).returns(false)

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
    should "deliver days" do
      days = Day.days_for_project(@project)
      assert_equal 3, days.length
      assert days[0].timestamp.same_time_as?(2.days.ago)
      assert days[1].timestamp.same_time_as?(1.day.ago)
      assert days[2].timestamp.same_time_as?(Time.now)
    end
    should "deliver points which are not yet done" do
      days = Day.days_for_project(@project)
      assert_equal  6, days[0].points_undone_all
      assert_equal 10, days[1].points_undone_all
      assert_equal  8, days[2].points_undone_all
    end
    should "deliver points not yet done, from the top" do
      days = Day.days_for_project(@project)
      assert_equal 11.0, days[0].points_undone_all_from_top
      assert_equal 11.0, days[1].points_undone_all_from_top
      assert_equal 8.0, days[2].points_undone_all_from_top
    end
    should "deliver overall speed" do
      days = Day.days_for_project(@project)
      assert_equal 2.0,  days[0].speed_overall
      assert_equal 1.0,  days[1].speed_overall
      assert_equal 1.67, days[2].speed_overall
    end
    should "deliver points done that day" do
      days = Day.days_for_project(@project)
      assert_equal 2, days[0].points_done_today
      assert_equal 0, days[1].points_done_today
      assert_equal 3, days[2].points_done_today
    end
    should "deliver speed of that iteration" do
      days = Day.days_for_project(@project)
      assert_equal 1.67, days[0].speed_iteration
      assert_equal 1.67, days[1].speed_iteration
      assert_equal 1.67, days[2].speed_iteration
    end
    should "deliver cumulated speed of that iteration" do
      days = Day.days_for_project(@project)
      assert_equal 1.67, days[0].speed_iteration_cumulated
      assert_equal 3.34, days[1].speed_iteration_cumulated
      assert_equal 5.01, days[2].speed_iteration_cumulated
    end
    should "deliver points to do per day" do
      days = Day.days_for_project(@project)
      assert_equal  8, days[0].points_to_do
      assert_equal 12, days[1].points_to_do
      assert_equal 13, days[2].points_to_do
    end
    should "deliver overall points done" do
      days = Day.days_for_project(@project)
      assert_equal 2, days[0].points_done_all
      assert_equal 2, days[1].points_done_all
      assert_equal 5, days[2].points_done_all
    end
  end

  context"days_for_project for an every day project" do
    setup do
      @project = create_project
      @project.stubs(:every_day_project?).returns(true)

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
    teardown do
      Time.advance_by_days  = 0
    end
    should "deliver days" do
      days = Day.days_for_project(@project)
      assert_equal 5, days.length
      assert days[0].timestamp.same_time_as?(2.days.ago)
      assert days[1].timestamp.same_time_as?(1.day.ago)
      assert days[2].timestamp.same_time_as?(Time.now)
    end
    should "deliver points not yet done" do
      days = Day.days_for_project(@project)
      assert_equal  6, days[0].points_undone_all
      assert_equal 10, days[1].points_undone_all
      assert_equal  8, days[2].points_undone_all
    end
    should "deliver points not yet done, from the top" do
      days = Day.days_for_project(@project)
      assert_equal 11.0, days[0].points_undone_all_from_top
      assert_equal 11.0, days[1].points_undone_all_from_top
      assert_equal  8.0, days[2].points_undone_all_from_top
    end
    should "deliver overall speed" do
      days = Day.days_for_project(@project)
      assert_equal 2.0 , days[0].speed_overall
      assert_equal 1.0 , days[1].speed_overall
      assert_equal 1.67, days[2].speed_overall
    end
    should "deliver points done that day" do
      days = Day.days_for_project(@project)
      assert_equal 2, days[0].points_done_today
      assert_equal 0, days[1].points_done_today
      assert_equal 3, days[2].points_done_today
    end
    should "deliver speed of that iteration" do
      days = Day.days_for_project(@project)
      assert_equal 1.0, days[0].speed_iteration
      assert_equal 1.0, days[1].speed_iteration
      assert_equal 1.0, days[2].speed_iteration
    end
    should "deliver cumulated speed of that iteration" do
      days = Day.days_for_project(@project)
      assert_equal 1.0, days[0].speed_iteration_cumulated
      assert_equal 2.0, days[1].speed_iteration_cumulated
      assert_equal 3.0, days[2].speed_iteration_cumulated
    end
    should "deliver points to do per day" do
      days = Day.days_for_project(@project)
      assert_equal  8, days[0].points_to_do
      assert_equal 12, days[1].points_to_do
      assert_equal 13, days[2].points_to_do
    end
    should "deliver overall points done" do
      days = Day.days_for_project(@project)
      assert_equal 2, days[0].points_done_all
      assert_equal 2, days[1].points_done_all
      assert_equal 5, days[2].points_done_all
    end
  end

end
