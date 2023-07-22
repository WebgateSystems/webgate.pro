class AdminAuthConstraint
  def matches?(request)
    return false unless request.session[:user_id]

    User.find_by(id: request.session[:user_id])
  end
end
