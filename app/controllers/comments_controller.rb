class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.js 
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = Comment.new(:event_id => params[:event_id], :parent_id => params[:parent_id])

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id if current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to_target_or_default(root_url, :notice => 'Comment was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to_target_or_default(root_url) }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to_target_or_default(root_url) }
      format.js
    end
  end
end
