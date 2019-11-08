module FlashHelper
  def alert_class(name, msg)
    if name.to_s == 'success' || msg.include?('success')
      'alert alert-success'
    elsif name.to_s == 'error' || msg.include?('not')
      'alert alert-danger'
    else
      'alert alert-info'
    end
  end
end
