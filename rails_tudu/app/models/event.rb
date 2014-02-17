class Event < ActiveRecord::Base
  def self.in_range begin_time, end_time
    Event.where(:start_time => begin_time..end_time)
  end
end
