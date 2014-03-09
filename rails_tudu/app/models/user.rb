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

	def tasks_with_deadline_in_range start_time, end_time
		self.tasks.where(:deadline => [start_time..end_time, nil])
	end

  # make a schedule for all of our tasks. This does
  # not actually commit the schedule, it only returns
  # a list of tasks with their start and end times filled
  # in.
  #
  # Also, tudusched is kinda kludgey. I'm needing to do a lot of weird
  # stuff to massage the data into a form it likes. It might be worth
  # looking into rewriting the way tudusched works to make it more polymorphic
  # when it comes to taking things that look like tasks and things that look
  # like events.
	def make_schedule start_time, end_time
		relevant_events = events_in_range start_time, end_time
		relevant_tasks = tasks_with_deadline_in_range start_time, end_time

		manifest_h = {}
		manifest_h['start'] = start_time.to_s
		manifest_h['end'] = end_time.to_s
		manifest_h['schedule'] = relevant_events.map{|e|
			h = {}
			h['start'] = e.start_time.to_s
			h['end'] = e.end_time.to_s
			# this is preeeeeeetty kludgey. Tudusched really
			# needs some work :(
			h['name'] = e.id.to_s

			h
		}
		manifest_h['tasks'] = relevant_tasks.map{|e|
			h = {}
			h['name'] = e.id.to_s
			h['time'] = e.duration
			h['importance'] = e.priority
			h['due'] = e.deadline.to_s

			h
		}

		tasks_hash = {}
		relevant_tasks.each do |e|
			tasks_hash[e.id.to_s] = e
		end

		m = Tudusched::Manifest.new manifest_h

		if not m.schedule_tasks
			return false
		end

		m.schedule.each do |e|
			if not e.scheduled
				next
			end

			mytask = tasks_hash[e.name]
			mytask.start_time = e.start_time
			mytask.end_time = e.end_time

			print "updating #{mytask}"

			mytask.save
		end

		true
	end

	def test_make_schedule
		make_schedule Time.now - 5.weeks, Time.now + 5.weeks
	end
end