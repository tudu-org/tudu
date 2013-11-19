class User < ActiveRecord::Base
	validates :email,:password,:password_confirmation, presence: true
	validates :email, 
					format: /@/, 
					uniqueness: true
	validates :password,
					length: { within: 8..20},
					format: {with: /^[a-zA-Z]\w{8,20}$/,multiline: true}, #dont leave this, securityerror, change the password format too
					confirmation: true
	validates :password_confirmation,  presence: true
	#validates :terms_of_service, acceptance: true
end