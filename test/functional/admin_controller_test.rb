require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase

  context "routing" do
    should "map index" do
      assert_routing '/admin',
        {:controller => 'admin', :action => 'index'}
    end
  end

  context "access control" do
    should "require an admin" do
      [:index].each do |action|
        get action
        assert_redirected_to(new_session_path)
      end
    end
  end

end
