require File.dirname(__FILE__) + '/../test_helper'

class ApplicationControllerTest < ActionController::TestCase

  context 'implant_inviter_url' do
    setup do
      @user = create_user(:login => 'inviter')
    end
    should "handle simple urls" do
      assert_equal 'test.com?inviter=inviter', @controller.send(:implant_inviter_url, 'test.com', @user)
    end
    should "handle anchor urls" do
      assert_equal 'test.com?inviter=inviter#abc', @controller.send(:implant_inviter_url, 'test.com#abc', @user)
    end
    should "handle parameter urls" do
      assert_equal 'test.com?inviter=inviter&dude=alto', @controller.send(:implant_inviter_url, 'test.com?dude=alto', @user)
    end
    should "handle complex urls" do
      assert_equal 'test.com?inviter=inviter&dude=alto#abc', @controller.send(:implant_inviter_url, 'test.com?dude=alto#abc', @user)
    end
  end

end
