module SpecHelpersHelper
  def stub_logged_in(ret=true)
    stub!(:logged_in?).and_return(ret)
  end

  def stub_current_user(user=mock_user)
    stub!(:current_user).and_return(user)    
  end
end