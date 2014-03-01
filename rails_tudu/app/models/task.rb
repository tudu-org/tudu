class Task < ActiveRecord::Base
  attr_accessible :start_time, :end_time, :name, :description, :priority, :deadline
end
