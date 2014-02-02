class Task < ActiveRecord::Base
	attr_accessible :name, :description, :start_time, :end_time, :deadline, :priority
end
