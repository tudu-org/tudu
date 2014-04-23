class User < ActiveRecord::Base
	#attr_accessor remember_me
	#before_save :encrypt_password
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

	#def encrypt_password
	#	if password.present?
	#		self.password_salt = BCrypt::Engine.generate_salt
	#		self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
	#	end
	#end

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

	def self.free_times start_time, my_timed_data
		super_blocks = []

		Rails.logger.info my_timed_data

		# filter our things that end before our start_time
		my_timed_data = my_timed_data.select do |td|
		  td.end_time >= start_time
		end

		# sort by start_time
		my_timed_data = my_timed_data.sort_by do |td|
			td.start_time
		end

		# grab the first and rest elements
		first_timed_data, *rest_timed_data = my_timed_data
		if first_timed_data
			val = {
				start_time: first_timed_data.start_time,
				end_time: first_timed_data.end_time
			}
			# make sure we only make super blocks for the appropriate times
			if first_timed_data.start_time < start_time
				val[:start_time] = start_time
			end

			super_blocks.append(val)
		end

		# merge the rest into our super block
		rest_timed_data.each do |td|
			if (td.start_time <= super_blocks[-1][:end_time]) and (td.end_time > super_blocks[-1][:end_time])
				super_blocks[-1][:end_time] = td.end_time
			else
				super_blocks.append({
					start_time: td.start_time,
					end_time: td.end_time
					})
			end
		end

		# now invert our super block from busy times to free times
		inverted_super_blocks = []

		# if we don't even have any super blocks just return a list that
		# says everything from now till forever from now is free. It's
		# actually not "forever" perse, but hopefully this software is obsolete
		# by the year 9001
		if super_blocks.size == 0
			inverted_super_blocks.append({
				start_time: start_time,
				end_time: Time.new(9001)
				})

			return inverted_super_blocks
		end

		# if the first super block entry does not match our
		# start time make sure to create an extra entry to
		# account for this
		if super_blocks[0][:start_time] != start_time
			inverted_super_blocks.append({
				start_time: start_time,
				end_time: super_blocks[0][:start_time]
			})
		end

		Rails.logger.info super_blocks

		# iterate over the super blocks and find the
		# time between them and add them to inverted_super_blocks
		super_blocks.each_with_index do |sb, i|
			# if this is the last element just make it to where it
			# never ends
			if i == super_blocks.size - 1
				inverted_super_blocks.append({
					start_time: sb[:end_time],
					end_time: Time.new(9001)
					})
				next
			end

			# otherwise just append the gap between this time and the next
			inverted_super_blocks.append({
				start_time: sb[:end_time],
				end_time: super_blocks[i + 1][:start_time]
				})
		end

		return inverted_super_blocks
	end

	def schedule_tasks
		# load our task and events arrays
		t_a = tasks.where(:finished => false)
		e_a = events.to_a

		timed_events = e_a

		# clear any start and end times we've already calculated
		t_a.each do |t|
			t.start_time = nil
			t.end_time = nil
		end

		# sort the task list by priority
		t_a = t_a.sort_by do |t|
			t.priority
		end.reverse

		# start scheduling five minutes from now
		start_time = Time.now + 5.minutes

		# schedule each task
		t_a.each do |t|
			# get our current free blocks
			free_blocks = User.free_times start_time, timed_events
			# try to find a place it fits
			free_blocks.each do |fb|
				length = fb[:end_time] - fb[:start_time]
				# if we find a spot wedge that sucker in!
				if length >= t.duration
					t.start_time = fb[:start_time]
					t.end_time = t.start_time + t.duration
					# make sure to add it to our timed events list so we can
					# account for it
					timed_events.append t
				end
			end
		end

		# save the tasks
		t_a.each do |t|
			t.save!
		end
	end
end