class Admin::UsersController < ApplicationController
  layout "admin"
  before_filter :admin_required

  def index
    @users = User.find(:all, :order => 'created_at DESC')
  end

  def destroy
    user = User.find_by_url_slug(params[:id])
    user.delete!
    flash[:notice] = "User '#{user.login}' wurde gelöscht"
    StatusMailer.deliver_user_deleted(user, params[:comment])
    redirect_to admin_users_path
  end
  
  def undelete
    user = User.find_by_url_slug(params[:id])
    user.undelete!
    flash[:notice] = "User '#{user.login}' wurde reaktiviert"
    StatusMailer.deliver_user_undeleted(user, params[:comment])
    redirect_to admin_users_path
  end
end
