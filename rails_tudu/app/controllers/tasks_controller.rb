class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @user.tasks
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = @user.tasks.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = @user.tasks.create(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to [@user, @task], notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@user, @task] }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to [@user, @task], notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to user_tasks_url(@user) }
      format.json { head :no_content }
    end
  end

  # POST /tasks/schedule
  def schedule
    # kludgey. rework how we schedule tasks
    respond_to do |format|
      if @user.make_schedule Time.now, Time.now + 1.year
        format.json { render json: @user.tasks }
      else
        format.json { render json: "Failed to schedule tasks", status: 400}
      end
    end
  end
  
  # GET /tasks/today
  # GET /tasks/today.json
  def today
    today = Time.now.to_a
	today[0] = today[1] = today[2] = 0
	start_time = Time.local(*today)
	end_time = start_time + 86400 #24 Hours in seconds

    @tasks = @user.tasks
    @tasks = @tasks.where(start_time: (start_time..end_time))

    respond_to do |format|
      format.html { render text: "Unimplemented" }
      format.json { render json: @tasks }
    end	
  end

  # GET /tasks/in_range?start=datetime&end=datetime
  # GET /tasks/in_range.json?start=datetime&end=datetime
  def in_range
    start_time = DateTime.parse params[:start]
    end_time = DateTime.parse params[:end]

    @tasks = @user.tasks
    @tasks = @tasks.where(start_time: (start_time..end_time))

    respond_to do |format|
      format.html { render text: "Unimplemented" }
      format.json { render json: @tasks }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
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
    def task_params
      params.require(:task).permit(:start_time, :end_time, :name, :description, :priority, :deadline, :duration)
    end
end
