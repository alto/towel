# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  include ExceptionNotifiable 
  
  before_filter :check_for_inviter

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c8f09f9c73e16b08b06912d3403ec9e8'
  
  protected
    def verify_not_deleted
      yield
    rescue ActsAsDeletable::RecordDeleted => exp
      redirect_to deleted_record_path
      # render :file => "#{RAILS_ROOT}/public/404_deleted_record.html", :status => "404 Not Found"
    end  
    
    def check_for_inviter
      unless params["inviter"].blank?
        session[:inviter] = params.delete("inviter")
        redirect_to params
      end
      true
    end

    def implant_inviter_url(url, inviter)
      if url =~ /\?/
        url.gsub!('?', "?inviter=#{inviter.login}&")
      elsif url =~ /#/
        url.gsub!('#', "?inviter=#{inviter.login}#")
      else
        url += "?inviter=#{inviter.login}"
      end
      url
    end

    
end
