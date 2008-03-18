module ImageHelper

  def big_image_tag(image, html_options={}, options={})
    visualisable_image_tag(image, :big, html_options, options)
  end
  def medium_image_tag(image, html_options={}, options={})
    visualisable_image_tag(image, :medium, html_options, options)
  end
  def small_image_tag(image, html_options={}, options={})
    visualisable_image_tag(image, :small, html_options, options)
  end

  private
    def visualisable_image_tag(image, size, html_options={}, options={})
      if image
        image_tag(h(image.public_filename(size)), html_options)
      else
        case options[:classname]
        when 'User'
          image_tag("elements/el_default_icon_fan_user_#{size.to_s}.gif", html_options)
        else
          "" # image_tag('dummy_deed_pic.jpg', html_options)
        end
      end
    end

end
