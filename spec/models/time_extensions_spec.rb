require File.dirname(__FILE__) + '/../spec_helper'

describe Time, "diff_in_minutes" do
  it "should deliver difference in minutes" do
    Time.utc(2008,1,1,10,10).diff_in_minutes(Time.utc(2008,1,1,10,12)).should eql(2)
    Time.utc(2008,1,1,10,10).diff_in_minutes(Time.utc(2008,1,1,10,8)).should eql(2)
  end
end

describe Time, "diff_in_hours" do
  it "should deliver difference in hours" do
    Time.utc(2008,1,1,10,10).diff_in_hours(Time.utc(2008,1,1,11,12)).should eql(1)
    Time.utc(2008,1,1,10,10).diff_in_hours(Time.utc(2008,1,1,11,8)).should eql(0)
  end
end

describe Time, "diff_in_days" do
  it "should deliver difference in days" do
    Time.utc(2008,1,1,10,10).diff_in_days(Time.utc(2008,1,2,11,12)).should eql(1)
    Time.utc(2008,1,1,10,10).diff_in_days(Time.utc(2008,1,1,11,8)).should eql(0)
  end
end
