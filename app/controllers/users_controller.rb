class UsersController < ApplicationController  
  def new  
    @user = User.new  
  end
  def edit
  end

  def update
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
    
  def login_from_qq
    redirect_to "https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=100240376&redirect_uri=http://ec.happypeter.org/auth/qq/callback"
  end
  def login_with_qq
    redirect_to "https://graph.qq.com/oauth2.0/token?grant_type=authorization_code&client_id=100240376&client_secret=07e7230147cbab07661c0232eda07657&code=#{params[:code]}&state=1234&redirect_uri=http://ec.happypeter.org/auth/qq/callback"
  end
  def create  
    @user = User.new(params[:user])  
    if @user.save  
      session[:user_id] = @user.id 
      redirect_to root_url, :notice => "signed up!"  
    else  
      render "new"  
    end  
  end  

  def index
      @users = User.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
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
