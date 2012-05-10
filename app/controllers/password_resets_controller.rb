class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to "/password_mail_sent"
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
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
