class ProfilesController < ApplicationController
  before_action :require_admin!, only: :index
  before_action :all_users, only: :index
  before_action :set_user, only: %i[update show destroy]
  before_action :access, only: :show

  def update
    user = @user.update_attributes(profile_params)

    if user
      redirect_to profiles_path, notice: 'User was successfully updated'
    else
      @error_messages = @ticket.errors.full_messages
      redirect_to profiles_path, notice: 'An error occured while updating the ticket'
    end
  end

  def destroy
    @user.destroy

    redirect_to profiles_path, notice: 'User account was deleted succesfully'
  end

  private

  def access
    return if @user == current_user || admin?

    redirect_to profile_path(current_user)
  end

  def set_user
    @user = User.includes(:tickets).find(params[:id])
  end

  def all_users
    @users = User.all_users
  end

  def profile_params
    params.permit(%i[agent admin])
  end
end
