class TasksController < ApplicationController

before_action :set_user
before_action :set_task, only: [:show, :edit, :update, :destroy]

def index
	@tasks = @user.tasks
end

def new
	@task = @user.tasks.new
end

def show
end

def edit
end

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

def create_test
	render text: params[:task]["deadline"].inspect
end

def create#_test

	@task = @user.tasks.new(task_params)
	@task.start_time = @task.deadline
	
	Rails.logger.debug("task is #{@task}")
	
    respond_to do |format|
      if @task.save
        format.html { redirect_to [@user, @task], notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
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
		format.html{render text: "Unimplemented"}
		format.json{render json: @tasks}
	end
end

 def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end


private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

	def set_user
		@user = User.find(params[:user_id])
	end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:deadline, :name, :description, :priority)
    end
	
end
