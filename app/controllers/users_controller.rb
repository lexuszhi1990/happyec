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
    conn = Faraday.new(:url => 'https://graph.qq.com/')
    resp = conn.get do |req|       
      req.url '/oauth2.0/token'
      req.params['grant_type'] = 'authorization_code'
      req.params['client_id'] = 100240376
      req.params['client_secret'] = '07e7230147cbab07661c0232eda07657'
      req.params['code'] = params[:code]
      req.params['redirect_uri'] = 'http://ec.happypeter.org/auth/qq/callback'
    end


    @access_token = resp.body.to_s.split("&")[0].split("=")[1]
    #get it out of "access_token=186D73F9A3F462D22FEC6028C638E0DD&expires_in=7776000"

    # now get openid with access_token
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
    if @user.nil?
      # now pull out all user's info
      resp3 = conn.get do |req|       
        req.url '/user/get_user_info'
        req.params['access_token'] = @access_token.to_s
        req.params['oauth_consumer_key'] = 100240376
        req.params['openid'] = @openid.to_s
      end
      str3 = resp3.body.to_s
      hash2 = JSON str3
      @user = User.create_from_hash(hash2)
    end
    cookies.permanent[:token] = @user.token
    redirect_to root_url, :notice => @user.token
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "You have been logged out."
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
