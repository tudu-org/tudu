require 'test_helper'

class RecurringEventsControllerTest < ActionController::TestCase
  setup do
    @recurring_event = recurring_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recurring_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recurring_event" do
    assert_difference('RecurringEvent.count') do
      post :create, recurring_event: { description: @recurring_event.description, end_time: @recurring_event.end_time, every_friday: @recurring_event.every_friday, every_monday: @recurring_event.every_monday, every_saturday: @recurring_event.every_saturday, every_sunday: @recurring_event.every_sunday, every_thursday: @recurring_event.every_thursday, every_tuesday: @recurring_event.every_tuesday, every_wednesday: @recurring_event.every_wednesday, name: @recurring_event.name, recurring_end_time: @recurring_event.recurring_end_time, recurring_start_time: @recurring_event.recurring_start_time, start_time: @recurring_event.start_time, weeks_between: @recurring_event.weeks_between }
    end

    assert_redirected_to recurring_event_path(assigns(:recurring_event))
  end

  test "should show recurring_event" do
    get :show, id: @recurring_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recurring_event
    assert_response :success
  end

  test "should update recurring_event" do
    patch :update, id: @recurring_event, recurring_event: { description: @recurring_event.description, end_time: @recurring_event.end_time, every_friday: @recurring_event.every_friday, every_monday: @recurring_event.every_monday, every_saturday: @recurring_event.every_saturday, every_sunday: @recurring_event.every_sunday, every_thursday: @recurring_event.every_thursday, every_tuesday: @recurring_event.every_tuesday, every_wednesday: @recurring_event.every_wednesday, name: @recurring_event.name, recurring_end_time: @recurring_event.recurring_end_time, recurring_start_time: @recurring_event.recurring_start_time, start_time: @recurring_event.start_time, weeks_between: @recurring_event.weeks_between }
    assert_redirected_to recurring_event_path(assigns(:recurring_event))
  end

  test "should destroy recurring_event" do
    assert_difference('RecurringEvent.count', -1) do
      delete :destroy, id: @recurring_event
    end

    assert_redirected_to recurring_events_path
  end
end
