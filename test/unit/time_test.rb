require File.dirname(__FILE__) + '/../test_helper'

class ArrayTest < ActiveSupport::TestCase
  context "diff_in_minutes" do
    should "deliver difference in minutes" do
      assert_equal 2, Time.utc(2008,1,1,10,10).diff_in_minutes(Time.utc(2008,1,1,10,12))
      assert_equal 2, Time.utc(2008,1,1,10,10).diff_in_minutes(Time.utc(2008,1,1,10,8))
    end
  end

  context "diff_in_hours" do
    should "deliver difference in hours" do
      assert_equal 1, Time.utc(2008,1,1,10,10).diff_in_hours(Time.utc(2008,1,1,11,12))
      assert_equal 0, Time.utc(2008,1,1,10,10).diff_in_hours(Time.utc(2008,1,1,11,8))
    end
  end

  context "diff_in_days" do
    should "deliver difference in days" do
      assert_equal 1, Time.utc(2008,1,1,10,10).diff_in_days(Time.utc(2008,1,2,11,12))
      assert_equal 0, Time.utc(2008,1,1,10,10).diff_in_days(Time.utc(2008,1,1,11,8))
    end
  end
end
