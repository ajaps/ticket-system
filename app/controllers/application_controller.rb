class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def admin?
    current_user.admin
  end

  def agent?
    current_user.agent
  end

  def super_user?
    current_user.agent || current_user.admin
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
