require 'time'

module Tudusched
  class ScheduleEntry
    attr_reader :name, :start_time, :end_time

    def to_h
      out = {}

      out[:name] = name
      out[:start_time] = start_time
      out[:end_time] = end_time

      out
    end

    def initialize args={}
      @name = args[:name]
      @start_time = args[:start_time]
      @end_time = args[:end_time]
    end

    def self.initialize_from_hash args={}
      ScheduleEntry.new(:name => args['name'],
        :start_time => Time.parse(args['start']),
        :end_time => Time.parse(args['end']))
    end

    def length
      @end_time - @start_time
    end
  end
end
