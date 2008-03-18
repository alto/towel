require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationController, 'implant_inviter_url' do
  before do
    @user = mock_user(:login => 'inviter')
  end
  it "should handle simple urls" do
    controller.send(:implant_inviter_url, 'test.com', @user).should eql('test.com?inviter=inviter')
  end
  it "should handle anchor urls" do
    controller.send(:implant_inviter_url, 'test.com#abc', @user).should eql('test.com?inviter=inviter#abc')
  end
  it "should handle parameter urls" do
    controller.send(:implant_inviter_url, 'test.com?dude=alto', @user).should eql('test.com?inviter=inviter&dude=alto')
  end
  it "should handle complex urls" do
    controller.send(:implant_inviter_url, 'test.com?dude=alto#abc', @user).should eql('test.com?inviter=inviter&dude=alto#abc')
  end
end
