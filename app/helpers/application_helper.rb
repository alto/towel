module ApplicationHelper

  def button_submit_tag(label, html_options={})
    "<button name=\"commit\" type=\"submit\" #{tag_options(html_options)}><span>#{label}</span></button>"
    # submit_tag(label, html_options)
  end
  
  def button_link_to(name, options={}, html_options={})
    "<div class=\"inlightButton\">#{link_to(name,options,html_options)}</div>"
  end

  def button_link_to_function(name, *args, &block)
    "<div class=\"inlightButton\">#{link_to_function(name, *args, &block)}</div>"
  end

  def link_to_website(website, name=nil, html_options={})
    return (name || '<em>none</em>') if website.blank?
    link_to(name || website.gsub(/http:\/\//, ''), ensure_protocol(website), html_options)
  end
  
  def flash_error
    if flash[:error]
      "<div class=\"error\">#{flash[:error]}</div>"
    end
  end
  
  def display_date_and_time(date)
    return '' if date.nil?
    date.strftime(datetime_format)
  end
  def display_time(date)
    return '' if date.nil?
    date.strftime(time_format)
  end
  def display_date(date)
    return '' if date.nil?
    date.strftime(date_format)
  end
  
  def display_description(description)
    simple_format(description.blank? ? 'no description yet' : description)
  end

  def absolutize_url(path)
    return path if (path.match(/^http(s{0,1}):\/\//))
    path = "/" + path unless path.match(/^\//)
    "#{request.protocol}#{request.host_with_port}#{path}"
  end
    
  def calendar_tag(object, field)
    format              = '%Y-%m-%d'
    # format              = '%Y-%m-%d %H:%M'
    object_class_name   = object.class.to_s.underscore
    form_name_attribute = "#{object_class_name}[#{field.to_s}]"
    field_value         = object.send(field)
    
    calendariffic_input(false, 
      form_name_attribute, 
      'calendariffic/date.png', 
      "#{object_class_name}_#{field.to_s}",
      format, 
      field_value ? 
        field_value.strftime(format) : 
        nil, 
      { :readonly => 'true', :class => 'inlightInputReadOnly' },  # text attributes  
      {}  # image attributes
    )    
  end

  private
    def ensure_protocol(website)
      website =~ /^http/ ? website : "http://#{website}"
    end

    def date_format
      "%d.%m.%Y"
    end
    def datetime_format
      "%d.%m.%Y | %H:%M"
    end
    def time_format
      "%H:%M Uhr"
    end

end
