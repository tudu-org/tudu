class User < ActiveRecord::Base
	validates :email,:password,:password_confirmation, presence: true
	validates :email, 
					format: /@/, 
					uniqueness: true,
					length: { within: 8..20},
					format: {with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\A/},
					confirmation: true
	validates :password_confirmation,  presence: true
	validates :terms_of_service, acceptance: true
end