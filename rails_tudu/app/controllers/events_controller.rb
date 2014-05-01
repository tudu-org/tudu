class EventsController < ApplicationController
  before_action :set_user
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = @user.events
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = @user.events.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    session[:return_to] ||= request.referer

    @event = @user.events.create(event_params)

    Rails.logger.debug("event is #{@event}")

    respond_to do |format|
      if @event.save
        format.html { redirect_to :back, notice: 'Event was successfully created.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [@user, @event], notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to user_events_url }
      format.json { head :no_content }
    end
  end

  # GET /events/today
  # GET /events/today.json
  def today
    today = Time.now.to_a
	today[0] = today[1] = today[2] = 0
	start_time = Time.local(*today)
	end_time = start_time + 86400 #24 Hours in seconds
	
	@events = @user.events
    @events = @events.where(start_time: (start_time..end_time))

    respond_to do |format|
      format.html { render text: "Unimplemented" }
      format.json { render json: @events }
    end
	
  end

  # GET /events/in_range?start=datetime&end=datetime
  # GET /events/in_range.json?start=datetime&end=datetime
  def in_range
    start_time = DateTime.parse params[:start]
    end_time = DateTime.parse params[:end]

    @events = @user.events
    @events = @events.where(start_time: (start_time..end_time))

    respond_to do |format|
      format.html { render text: "Unimplemented" }
      format.json { render json: @events }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:start_time, :end_time, :name, :description)
    end
end
