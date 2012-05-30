class PostcommentsController < ApplicationController

  def edit
    @postcomment = Postcomment.find(params[:id])
  end

  def create
    @postcomment = Postcomment.new(params[:postcomment])

    respond_to do |format|
      if @postcomment.save
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
    @postcomment = Postcomment.find(params[:id])

    respond_to do |format|
      if @postcomment.update_attributes(params[:postcomment])
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

