class RecurringEventsController < ApplicationController
  before_action :set_recurring_event, only: [:show, :edit, :update, :destroy]

  # GET /recurring_events
  # GET /recurring_events.json
  def index
    @recurring_events = RecurringEvent.all
  end

  # GET /recurring_events/1
  # GET /recurring_events/1.json
  def show
  end

  # GET /recurring_events/new
  def new
    @recurring_event = RecurringEvent.new
  end

  # GET /recurring_events/1/edit
  def edit
  end

  # POST /recurring_events
  # POST /recurring_events.json
  def create
    @recurring_event = RecurringEvent.new(recurring_event_params)

    respond_to do |format|
      if @recurring_event.save
        format.html { redirect_to @recurring_event, notice: 'Recurring event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @recurring_event }
      else
        format.html { render action: 'new' }
        format.json { render json: @recurring_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recurring_events/1
  # PATCH/PUT /recurring_events/1.json
  def update
    respond_to do |format|
      if @recurring_event.update(recurring_event_params)
        format.html { redirect_to @recurring_event, notice: 'Recurring event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @recurring_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurring_events/1
  # DELETE /recurring_events/1.json
  def destroy
    @recurring_event.destroy
    respond_to do |format|
      format.html { redirect_to recurring_events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurring_event
      @recurring_event = RecurringEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recurring_event_params
      params.require(:recurring_event).permit(:recurring_start_time, :recurring_end_time, :start_time, :end_time, :every_monday, :every_tuesday, :every_wednesday, :every_thursday, :every_friday, :every_saturday, :every_sunday, :weeks_between, :name, :description)
    end
end
