module ApplicationHelper
  def admin?
    current_user&.admin?
  end

  def agent?
    current_user&.agent?
  end

  def super_user?
    current_user&.agent? || current_user&.admin?
  end

  def admin_display(content, alternate_content=nil)
    content if admin?

    alternate_content
  end

  def super_user_display(content, alternate_content=nil)
    content if super_user?

    alternate_content
  end
end
