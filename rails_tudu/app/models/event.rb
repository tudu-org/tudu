class Event < ActiveRecord::Base
  attr_accessible :start_time, :end_time, :name, :description
  def self.in_range begin_time, end_time
    Event.where(:start_time => begin_time..end_time)
  end
end
