class UsersController < ApplicationController

  before_filter :login_required, :only => [:show,:edit,:update]
  before_filter :load_user, :only => [:show]

  def show
    @page_title = @user.display_name
    @projects = @user.projects
  end

  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    if !session[:inviter].blank? && inviter = User.find_by_login(session[:inviter])
      @user.inviter = inviter
    end
    @user.save!
    # self.current_user = @user
    redirect_back_or_default('/')
    # flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate(params[:reactivation])
      flash[:notice] = "Änder jetzt Dein Kennwort!" if params[:reactivation]
      redirect_to edit_user_path(current_user)
    else
      redirect_back_or_default('/')
    end
  end

  def recover_password
    if request.post? && !params[:email].blank?
      if user = User.find_by_email(params[:email])
        user.reset_activation
        UserMailer.deliver_password_recover(user)
        render :action => 'password_recovered' and return
      else
        flash[:error] = 'Wir haben keinen Benutzer mit dieser Email-Adresse gefunden!'
      end
    end
  end

  private
    def load_user
      @user = User.find_by_url_slug(params[:id]) or raise ActiveRecord::RecordNotFound
    end
end
