class User < ActiveRecord::Base
	#attr_accessor remember_me
	before_save :encrypt_password
	before_create :set_auth_token
	has_secure_password

	validates_confirmation_of :password
	validates_presence_of :email, :on => :create
	validates :email, 
				format: {:message=> 'Email is invalid format' , with: /@/},
				uniqueness: true
	has_many :events
	has_many :recurring_events
	has_many :tasks
	
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

	def set_auth_token
		begin
			self.auth_token = SecureRandom.hex
		end while self.class.exists?(auth_token: self.auth_token)
	end

	def events_in_range start_time, end_time
		self.events.where('start_time BETWEEN :start_time AND :end_time OR end_time BETWEEN :start_time AND :end_time',
			:start_time => start_time,
			:end_time => end_time)
	end

	def tasks_with_deadline_in_range begin_time, end_time
		self.tasks.where(:deadline => begin_time..end_time)
	end
end