require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper, "display_date" do
  it "should deliver German date format" do
    display_date(Time.utc(2008,1,8)).should eql('08.01.2008')
  end
end

describe ApplicationHelper, "display_date_and_time" do
  it "should deliver German datetime format" do
    display_date_and_time(Time.utc(2008,1,8,10,13)).should eql('08.01.2008 | 10:13')
  end
end

describe ApplicationHelper, "display_time" do
  it "should deliver German time format" do
    display_time(Time.utc(2008,1,8,10,13)).should eql('10:13 Uhr')
  end
end

describe ApplicationHelper, "link_to_website" do
  it "should return none string on nil" do
    link_to_website(nil).should eql('<em>none</em>')
  end
  it "should return none string on empty website" do
    link_to_website('').should eql('<em>none</em>')
  end
  it "should provide a http link for urls with protocol" do
    link_to_website('http://mt7.de').should eql('<a href="http://mt7.de">mt7.de</a>')
  end
  it "should provide a http link for urls without protocol" do
    link_to_website('mt7.de').should eql('<a href="http://mt7.de">mt7.de</a>')
  end
end
