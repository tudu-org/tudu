class Task < ActiveRecord::Base
	attr_accessible :name, :description, :start_time, :end_time, :deadline, :priority
	def self.in_range begin_time end_time
		Task.where(:start_time => begin_time..end_time)
	end
end
