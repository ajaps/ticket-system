class ActivityPreviledge
  def initialize(activity, current_user)
    @activity = activity
    @current_user = current_user
  end

  def personalize
    return 'You' if @activity.user == @current_user

    @activity.user.name
  end

  def owner?
    @activity.user == @current_user
  end

  def can_comment?
    @current_user.super_user? || (@activity.status != 'closed' && @activity.comments?)
  end

  def user_tag
    return 'Admin' if @activity.user.admin
    return 'Support staff' if @activity.user.agent?
  end

  def assigned_to
    @activity.assignee&.name || 'None'
  end
end
