class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end 
end
