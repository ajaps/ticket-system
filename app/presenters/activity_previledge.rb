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

  def owner?
    @activity.user == @current_user
  end

  def can_comment?
    return true if super_user?

    @activity.status != 'closed' && @activity.comments?
  end

  def user_tag
    return 'Admin' if @activity.user.admin
    return 'Support staff' if @activity.user.agent?
  end

  def assigned_to
    @activity.assignee&.name || 'None'
  end
end
