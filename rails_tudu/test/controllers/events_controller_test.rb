require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
    @user = users(:one)
  end

  test "should get index" do
    get :index, user_id: @user.id
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new, user_id: @user.id
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post :create, user_id: @user.id, event: { description: @event.description, end_time: @event.end_time, name: @event.name, start_time: @event.start_time }
    end

    assert_redirected_to user_event_path(assigns(:event))
  end

  test "should show event" do
    get :show, user_id: @user.id, id: @event
    assert_response :success
  end

  test "should get edit" do
    get :edit, user_id: @user.id, id: @event
    assert_response :success
  end

  test "should update event" do
    assert_not_nil @user.id
    patch :update, user_id: @user.id, id: @event, event: { description: @event.description, end_time: @event.end_time, name: @event.name, start_time: @event.start_time }
    assert_redirected_to user_event_path(assigns(:event),user_id: @user.id, id: @event)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete :destroy, user_id: @user.id, id: @event
    end

    assert_redirected_to user_events_path
  end
end
