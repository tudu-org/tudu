require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
    @user = users(:one)
  end

  test "should get index" do
    get :index, user_id: @user.id
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new, user_id: @user.id
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, user_id: @user.id, task: { deadline: @task.deadline, description: @task.description, end_time: @task.end_time, name: @task.name, priority: @task.priority, start_time: @task.start_time }
    end

    assert_redirected_to user_task_path(assigns(:task))
  end

  test "should show task" do
    get :show, user_id: @user.id, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, user_id: @user.id, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, user_id: @user.id, id: @task, task: { deadline: @task.deadline, description: @task.description, end_time: @task.end_time, name: @task.name, priority: @task.priority, start_time: @task.start_time }
    assert_redirected_to user_task_path(assigns(:task), user_id: @user.id,id: @task)
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, user_id: @user.id, id: @task
    end

    assert_redirected_to user_tasks_path
  end
end
