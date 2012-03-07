class UsersController < ApplicationController  
  def new  
    @user = User.new  
  end
  def new_mail  
    @user = User.new  
  end
  def edit
    @user = User.find(params[:id])
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
    
  def login_from_qq
    @auth_url = "https://graph.qq.com/oauth2.0/authorize"
    redirect_to @auth_url + "?response_type=code&client_id="+APP_CONFIG["qq_app_id"].to_s+"&redirect_uri=http://ec.happypeter.org/auth/qq/callback"
  end

  def login_with_qq
    conn = Faraday.new(:url => 'https://graph.qq.com/')
    # step1: get access_token
    resp = conn.get do |req|       
      req.url '/oauth2.0/token'
      req.params['grant_type'] = 'authorization_code'
      req.params['client_id'] = APP_CONFIG["qq_app_id"].to_s
      req.params['client_secret'] = APP_CONFIG["qq_key"].to_s
      req.params['code'] = params[:code]
      req.params['redirect_uri'] = 'http://ec.happypeter.org/auth/qq/callback'
    end
    @access_token = resp.body.to_s.split("&")[0].split("=")[1]
    #get it out of "access_token=186D73F9A3F462D22FEC6028C638E0DD&expires_in=7776000"

    # step2: get openid with access_token
    resp2 = conn.get do |req|       
      req.url '/oauth2.0/me'
      req.params['access_token'] = @access_token.to_s
    end
    str = resp2.body.to_s #callback( {"client_id":"100240376","openid":"B8B8CF6AB35A92FBF796615A74063BD6"} );
    str2=str[9,70]

    require 'json'
    hash = JSON str2
    @openid = hash["openid"]
    @user = User.find_by_qqopenid(hash["openid"]) 
    if @user == nil
      # step3: pull out all user's info
      resp3 = conn.get do |req|       
        req.url '/user/get_user_info'
        req.params['access_token'] = @access_token.to_s
        req.params['oauth_consumer_key'] = 100240376
        req.params['openid'] = @openid.to_s
      end
      str3 = resp3.body.to_s
      hash2 = JSON str3
      @user = User.create_from_hash(hash2, hash["openid"])
    end
    cookies.permanent[:token] = @user.token
    redirect_to root_url, :notice => @user.token
  end

  def login  #login with a local account
    user = User.authenticate(params[:name], params[:password])  
    if user
      cookies.permanent[:token] = user.token
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.alert = "Invalid name or password"
      redirect_to :action => "new"
    end
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "You have been logged out."
  end

  def sendmail 
    @mailbody = "hello"
    PeterMailer.send_to_all(@mailbody).deliver
    redirect_to root_url, :notice => "signed up!"  
  end  
  def create  
    @user = User.new(params[:user])  
    if @user.save  
      PeterMailer.registration_confirmation(@user).deliver
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
