class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tickets = current_user.tickets
  end
end
