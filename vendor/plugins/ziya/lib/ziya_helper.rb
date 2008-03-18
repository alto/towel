require 'cgi'

module Ziya
  module Helper  
    
    CHART_PATH = "/charts" unless defined? CHART_PATH
    XML_SWF    = "%s/charts.swf?library_path=%s/charts_library&xml_source=%s" unless defined? XML_SWF
    CLASSID    = "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" unless defined? CLASS_ID
    CODEBASE   = "http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" unless defined? CODEBASE
                        
    # -------------------------------------------------------------------------------------
    # Generates chart object tag with given url to fetch the xml data  
    # -------------------------------------------------------------------------------------            
    def ziya_chart( url, chart_options = {} )
      options = { :width          => "400",
                  :height         => "300",
                  :align          => "left",
                  :class          => "",        
                  :id             => "ziya_chart",
                  :swf_path       => CHART_PATH,
                  :cache          => false,
                  :timeout        => nil,
                  :use_stage      => true,
                  :style          => ""
                }.merge!(chart_options)

      # Escape url
      url = CGI.escape( url.gsub( /&amp;/, '&' ) )

      # Set the wmode to opaque if a bgcolor is specified. If not set to
      # transparent mode unless user overrides it
      if options[:bgcolor]
        options[:wmode] = "opaque" unless options[:wmode]
      else
        options[:wmode]   = "transparent" unless options[:wmode]
        options[:bgcolor] = "#FFFFFF"
      end
      color_param  = tag( 'param', {:name => 'bgcolor', :value => options[:bgcolor]}, true )
      color_param += tag( 'param', {:name  => "wmode", :value => options[:wmode]}, true )

      # Check args for size option (Submitted by Sam Livingston-Gray)                                  
      if options[:size] =~ /(\d+)x(\d+)/
        options[:width]  = $1
        options[:height] = $2
        options.delete :size
      end
                             
      xml_swf_path = XML_SWF % [options[:swf_path], options[:swf_path], url ]
      xml_swf_path << "&timestamp=#{Time.now.to_i}" if options[:cache] == false
      xml_swf_path << "&timeout=#{options[:timeout]}" if options[:timeout]
      xml_swf_path << "&stage_width=#{options[:width]}&stage_height=#{options[:height]}" if options[:use_stage] == true 
      content_tag( 'object',
        tag( 'param',
         {:name  => "movie",
         :value =>  xml_swf_path}, true ) +
        tag( 'param', 
         {:name  => "quality",
         :value => "high"}, true )  +
        content_tag( 'embed', nil, 
         :src           => xml_swf_path,
         :quality       => 'high', 
         :bgcolor       => options[:bgcolor],
         :wmode         => options[:wmode], 
         :width         => options[:width], 
         :height        => options[:height], 
         :name          => options[:id], 
         :swLiveConnect => "true", 
         :type          => "application/x-shockwave-flash",
         :pluginspage   => "http://www.macromedia.com/go/getflashplayer") +
        color_param,
        :classid     => CLASSID,
        :codebase    => CODEBASE,
        :data        => xml_swf_path, 
        :style       => options[:style],
        :width       => options[:width], :height => options[:height], 
        :stage_width => options[:width], :stage_height => options[:height], :id => options[:id] )
    end          
                        
    # -------------------------------------------------------------------------------------
    # Generate chart tag with given action name for fetch the xml data  
    # IMPORTANT THIS CALL WILL BE DEPRECATED - Use ziya_chart instead
    # -------------------------------------------------------------------------------------
    def gen_chart( id, source_name, bgcolor, width, height, options={} )
      RAILS_DEFAULT_LOGGER.error "WARNING !! gen_chart will be deprecated. Please use ziya_chart instead"
      
      source_name = CGI.escape( source_name.gsub( /&amp;/, '&' ) )
      content_tag( 'object', 
      content_tag( 'param', nil, 
       :name  => options[:id], 
       :value => "/charts/charts.swf?library_path=/charts/charts_library&xml_source=#{source_name}" ) +
      content_tag( 'param', nil, 
         :name  => "quality", 
         :value => "high" ) +
      content_tag( 'param', nil, 
         :name  => "bgcolor", 
         :value => "#{bgcolor}" ) +
      content_tag( 'param', nil, 
         :name  => "border", 
         :value => "0px" ) +
      content_tag( 'embed', nil, 
       :src    => "/charts/charts.swf?library_path=/charts/charts_library&xml_source=#{source_name}",
       :quality       => 'high', 
       :bgcolor       => bgcolor, 
       :width         => "#{width}", 
       :height        => "#{height}", 
       :name          => id, 
       :swLiveConnect => "true", 
       :type          => "application/x-shockwave-flash",
       :pluginspage   => "http://www.macromedia.com/go/getflashplayer"),
       :classid       => "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",
       :codebase      => "http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0",
       :width         => "#{width}", 
       :height        => "#{height}", 
       :style         => "border:none;display:inline",
       :id            => id )
    end                                    
  end
end
