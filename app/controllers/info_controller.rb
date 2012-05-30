class InfoController < ApplicationController
  def timeline
  end
  def index
    @streamEvents = StreamEvent.all  
  end

  def about
    @title = "Happyec helps people make friends learning English"
  end
  def location
    @title = "Find us, and join us!"
  end
  def people
    @title = "A place to show off your talents."
    @users = User.all
  end
  def password_mail_sent_notice
  end
end
