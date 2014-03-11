require 'test_helper'
class UsersControllerTest < ActionController::TestCase
  	setup do
  		@user = users(:one)
  		@update = {
  			email: 'test2@example.com',
  			password: 'secret',
  			password_confirmation: 'secret'
  		}
  	end
  	test "should get index" do
  		get :index
  		assert_response :success
  		assert_not_nil assigns(:users)
  	end
	test "should create user" do 
  		assert_difference('User.count') do 
  			post :create, user: { email: 'test@example.com', password: 'secret',
  				password_confirmation: 'secret' }
  		end
  		assert_redirected_to login_path
	end
	test "should update user" do 
		patch :update, id: @user, user: @update
		assert_redirected_to login_path
	end
	test "should show" do
		get :show, id: @user
		assert_response :success
		assert_not_nil assigns(:users)
	end
	test "should find by email" do
		get :by_email, id: @user
		assert_response :success
		assert_not_nil assigns(:users)
	end
	test "should schedule" do
		get :schedule, user_id: @user
		assert_response :success
		assert_not_nil assigns(:users)
	end
end
