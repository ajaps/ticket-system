class ActivityPreviledge
  def initialize(activity, current_user)
    @activity = activity
    @current_user = current_user
  end

  def admin?
    @activity.user.admin
  end

  def agent?
    @activity.user.agent
  end

  def personalize
    return 'You' if @activity.user == @current_user

    @activity.user.name
  end

  def super_user?
    @activity.user.agent || @activity.user.admin
  end

  def user_tag
    return 'Admin' if @activity.user.admin
    return 'Support staff' if @activity.user.agent?
  end
end
