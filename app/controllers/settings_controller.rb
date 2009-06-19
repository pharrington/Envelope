class SettingsController < ApplicationController
  before_filter :require_user

  def edit
    @settings = current_user.settings || current_user.create_settings
  end
  def update
    current_user.settings.update_attributes! params[:settings]
    flash[:notice] = "Settings updated."
    redirect_to edit_settings_path
  end
end
