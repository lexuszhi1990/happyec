class PeterMailer < ActionMailer::Base
  default :from => "no-reply@happyec.org" 
  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end
  def mail_to_all(user, mailbody)
    @mailbody = mailbody
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Happyec Weekly Meetup")
  end
  def password_reset(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Password Reset")    
  end     
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
end
