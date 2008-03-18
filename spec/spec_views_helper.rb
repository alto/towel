module SpecViewsHelper
  def stub_login(user=mock_user)
    stub_logged_in
    stub_current_user(user)
  end

  def stub_image_tags
    @controller.template.stub!(:big_image_tag).and_return('image_stub')
    @controller.template.stub!(:medium_image_tag).and_return('image_stub')
    @controller.template.stub!(:small_image_tag).and_return('image_stub')
  end

  def stub_logged_in(ret=true)
    @controller.template.stub!(:logged_in?).and_return(ret)
  end

  def stub_current_user(user=mock_user)
    @controller.template.stub!(:current_user).and_return(user)    
  end

  def stub_may_imaginate(ret=true)
    @controller.template.stub!(:may_imaginate?).and_return(ret)
  end

  def stub_map
    assigns[:map] = mock_model(GMap, :to_html => 'map', :div => '<div id="div_map">map</div>')
    assigns[:marker] = {:draggable => true, :zoom_level => 5, :latlon => '1,1'}
  end
end
