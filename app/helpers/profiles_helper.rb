module ProfilesHelper
  def user_type(user)
    if user.admin
      'ADMIN'
    elsif user.agent
      'Support Staff'
    else
      'Customer'
    end
  end
end
