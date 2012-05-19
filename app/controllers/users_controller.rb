class UsersController < ApplicationController  
  def new  
    @user = User.new  
  end
  def newmail  
    @user = User.new  
  end
  def edit
    @user = User.find(current_user.id)
  end
  def account 
    redirect_to set_profile_path
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'Profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end  

  def login
    session[:return_to] = nil
    session[:return_to] = params[:return_to] if params[:return_to]
  end

  def auth
    user = User.authenticate(params[:name], params[:password])  
    if user
      if !user.auth_token.present?
        # for my old db record where no such colum
        User.add_auth_token(user)
      end
      cookies.permanent[:auth_token] = user.auth_token
      redirect_to_target_or_default root_url, :notice => "Logged in!"

    else
      flash.alert = "Incorrect name or password"
      redirect_to :action => "login"
    end
  end

  def logout
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "You have been logged out."
  end

  def sendmail 
    @mailbody = params[:mailbody]
    User.all.each do |u|
      PeterMailer.mail_to_all(u, @mailbody).deliver
    end
    redirect_to root_url, :notice => "Mail sent!"  
  end  
  def create  
    @user = User.new(params[:user])  
    if @user.save  
      PeterMailer.registration_confirmation(@user).deliver
      cookies.permanent[:auth_token] = @user.auth_token
      redirect_to user_path(@user), :notice => "signed up!"
    else  
      render "new"  
    end  
  end  


  def show
    session[:return_to] = request.url
    if params[:name]
      @user = User.where(:name => params[:name]).first
    else
      @user = User.find(params[:id])
    end

    if @user == nil
      redirect_to root_url, :notice => "no such user!"  
    else
      respond_to do |format|
        format.html # show.html.erb
      end
    end
  end
end
