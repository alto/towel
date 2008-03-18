require File.dirname(__FILE__) + '/../spec_helper'

describe Array, "window" do
  it "should deliver window_around_index" do
    mine = [0,1,2,3,4,5,6,7,8,9]
    mine.window_around_index(0,0).should eql([0])
    mine.window_around_index(0,1).should eql([0,1])
    mine.window_around_index(9,0).should eql([9])
    mine.window_around_index(9,1).should eql([8,9])
    mine.window_around_index(4,2).should eql([2,3,4,5,6])
  end
  it "should deliver window_around_element" do
    mine = ['0','1','2','3','4','5','6','7','8','9']
    mine.window_around_element('0',0).should eql(['0'])
    mine.window_around_element('0',1).should eql(['0','1'])
    mine.window_around_element('9',0).should eql(['9'])
    mine.window_around_element('9',1).should eql(['8','9'])
    mine.window_around_element('4',2).should eql(['2','3','4','5','6'])
  end
end