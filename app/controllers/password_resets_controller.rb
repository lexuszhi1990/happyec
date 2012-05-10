class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user.nil?
      redirect_to forget_password_path, :alert => "Can't find that email, sorry."
    else
      redirect_to "/password_mail_sent", :notice => "#{user.email}"
    end
  end

  def edit
    @user = User.find_by_password_reset_token(params[:id])
    if @user.nil? # this happens when user click twice the sendmail button, and get more than one mail, but not use the lastest mail
      redirect_to forget_password_path,:alert =>"Invalid login token; please enter your email again." 
    end
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to forget_password_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      cookies.permanent[:auth_token] = @user.auth_token # login the user now
      redirect_to set_profile_path, :notice => "New password set successfully."
    else
      render :edit
    end
  end
end
