class SessionsController < ApplicationController
  layout 'session'
  def new; end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to admin_root_url, notice: t(:logged_in)
    else
      flash[:error] = t(:email_or_password_invalid)
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: t(:logged_out)
  end
end
