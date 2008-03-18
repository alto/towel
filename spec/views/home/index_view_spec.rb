require File.dirname(__FILE__) + '/../../spec_helper'

describe "/ (root)" do
  before do
  end
  it "should render" do
    render '/home/index'
  end
end
