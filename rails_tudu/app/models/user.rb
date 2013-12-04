class User < ActiveRecord::Base
	attr_accessible :email, :password, :password_confirmation
	attr_accessor :password
	before_save :encrypt_password
	validates :password,
				length: { within: 8..20},
				format: {:message=> 'The password must be between 8 and 20 characters ', with: /^[a-zA-Z]\w{8,20}$/,multiline: true} #dont leave this, securityerror, change the password format too

	validates_confirmation_of :password
	validates_presence_of :password, :on => :create
	validates_presence_of :email, :on => :create
	validates :email, 
				format: /@/, 
				uniqueness: true
	
	#validates :terms_of_service, acceptance: true
	def initialize(attributes = {})
		super
		attributes.each do |name, value|
			send("#{name}=",value)
		end
	end

	def self.authenticate_by_email(email,password)
		user = find_by_email(email)
		if user && user.password_hash == BCrypt::Engine.hash_secret(password,user.password_salt)
			user
		else
			nil
		end
	end
	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
		end
	end

end