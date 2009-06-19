class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  def new
    @user_session = UserSession.new
  end
  def create
    @user_session = UserSession.new(params[:user_session])
    unless @user_session.save
      flash[:notice] = "Failed to login."
      render :action => 'new'
      return
    end
    redirect_back_or_to emails_path
  end
  def destroy
    current_user_session.destroy
  end
end
