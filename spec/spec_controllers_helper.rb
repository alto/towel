module SpecControllersHelper
  def stub_logged_in(ret=true)
    @controller.stub!(:logged_in?).and_return(ret)
  end
end
