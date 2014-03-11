require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test "user should have auth token" do
		user = User.new(email: "four@example.com", password: "secret",password_confirmation: "secret")
		assert_nil(user.auth_token)
		user.save
		assert_not_nil(user.auth_token)
	end
	
end
