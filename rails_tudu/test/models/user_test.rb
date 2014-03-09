require 'test_helper'

class UserTest < ActiveSupport::TestCase
	test "user attributes not empty" do
		user = User.new
		assert user.invalid?
		assert user.errors[:email].any?
		assert user.errors[:password].any?
		assert user.errors[:password_confirmation].any?
	end
end
