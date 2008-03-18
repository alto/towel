class HomeController < ApplicationController

  def index
  end
  
  def deleted_record
    render :status => 404
  end
  
  def imprint
  end
  
  def terms_of_service
  end
  
  def contact
    if request.post?
      @name     = logged_in? ? current_user.display_name : params[:name]
      @email    = logged_in? ? current_user.email : params[:email]
      @subject  = params[:subject]
      @body     = params[:body]
      if !@name.blank? && !@email.blank? && !@subject.blank? && !@body.blank? && (@email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
        SystemMailer.deliver_contact(@name, @email, @subject, @body)
        flash[:notice] = 'Deine Nachricht wurde versendet.'
        redirect_back_or_default('/')
      else
        flash[:error] = '<h2>Bitte angeben:</h2><ul>'
        flash[:error] += '<li>Name</li>'                  if @name.blank?
        flash[:error] += '<li>Emailadresse</li>'          if @email.blank?
        flash[:error] += '<li>gültige Emailadresse</li>'  if !@email.blank? && !(@email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
        flash[:error] += '<li>Betreff</li>'               if @subject.blank?
        flash[:error] += '<li>Nachricht</li>'             if @body.blank?
        flash[:error] += '</ul>'
      end
    end
  end
  def example
    # MiddleMan.new_worker(:worker => :example_worker, :job_key => :example_worker)
    MiddleMan.ask_work(:worker => :example_worker, :worker_method => :do_work, :data => 'dude')
    # MiddleMan.delete_worker(:worker => :example_worker, :job_key => :example_worker)
  rescue BackgrounDRb::BdrbConnError
    flash[:error] = 'BackgrounDRb Server antwortet nicht'
  end
end
