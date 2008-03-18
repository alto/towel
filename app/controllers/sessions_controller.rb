# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      respond_to do |format|
        format.html do
          flash[:notice] = "Logged in successfully"
          redirect_back_or_default(user_path(current_user))
        end
        format.js do
          render :update do |page|
            if params[:show_element_id].blank?
              page << 'Erfolgreich eingeloggt!'
            else
              page << "toggle_on_player_area('#{params[:show_element_id]}');"
            end
          end
        end
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.js   { render :nothing => true, :status => 204}
      end
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
