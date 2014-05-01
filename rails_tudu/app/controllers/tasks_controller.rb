class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:show, :edit, :update, :destroy, :finished]

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
        @user.schedule_tasks
        format.html { redirect_to :back, notice: 'Task was successfully created.' }
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
        @user.schedule_tasks

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
    @user.schedule_tasks
    respond_to do |format|
      format.html { redirect_to user_tasks_url(@user) }
      format.json { head :no_content }
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

  # PUT /tasks/1/finished
  # PUT /users/1/tasks/1/finished
  # PUT /tasks/1/finished.json
  # PUT /users/1/tasks/1/finished.json
  def finished
    @task.finished = true

    respond_to do |format|
      if @task.save
        format.html { render text: "Unimplemented" }
        format.json { head :no_content }
      else
        format.html { render text: "Unimplemented" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      task_id = params[:id]
      if params[:task_id]
        task_id = params[:task_id]
      end

      @task = Task.find(task_id)
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
      params.require(:task).permit(:start_time, :end_time, :name, :description, :priority, :deadline, :duration, :finished)
    end
end
