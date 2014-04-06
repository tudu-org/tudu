class Task < ActiveRecord::Base
  attr_accessible :start_time, :end_time, :name, :description, :priority, :deadline, :duration, :finished
  def self.in_range begin_time, end_time
    Task.where(:start_time => begin_time..end_time)
  end
end
