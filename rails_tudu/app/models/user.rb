class User < ActiveRecord::Base
	#attr_accessor remember_me
	before_save :encrypt_password
	has_secure_password

	validates_confirmation_of :password
	validates_presence_of :email, :on => :create
	validates :email, 
				format: {:message=> 'Email is invalid format' , with: /@/},
				uniqueness: true
	has_many :events
	has_many :recurring_events
	
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