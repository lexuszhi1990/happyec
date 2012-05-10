class InfoController < ApplicationController
  def about
    @title = "Happyec helps people make friends learning English"
  end
  def location
    @title = "Find us, and join us!"
  end
  def people
    @title = "We give people chance to do show off their talent."
    @users = User.all
  end
  def password_mail_sent_notice
  end
end
