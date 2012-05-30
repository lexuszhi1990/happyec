class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    @events = Event.all
    session[:return_to] = request.url
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
  def show
    @event = Event.find(params[:id])
    session[:return_to] = request.url

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  def new
    @event = Event.new
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.js
    end
  end
end
