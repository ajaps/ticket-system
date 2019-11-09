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

  def require_super_user!
    return if super_user?

    flash[:error] = 'You must be a super-user to perform this operation'
    redirect_to root_path
  end

  def require_admin!
    return if admin?

    flash[:error] = 'You must be an Admin to perform this operation'
    redirect_to root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
