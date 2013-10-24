require 'time'

module Tudusched
  class ScheduleEntry
    attr_reader :name, :start_time, :end_time, :scheduled

    def to_h
      out = {}

      out[:name] = name
      out[:start_time] = start_time
      out[:end_time] = end_time
      out[:scheduled] = scheduled

      out
    end

    def initialize args={}
      @name = args[:name]
      @start_time = args[:start_time]
      @end_time = args[:end_time]
      @scheduled = args[:scheduled]
    end

    def self.initialize_from_hash args={}
      ScheduleEntry.new(:name => args['name'],
        :start_time => Time.parse(args['start']),
        :end_time => Time.parse(args['end']))
    end

    def length
      @end_time - @start_time
    end

    def to_gcal_entry
      {
        'start' => {'dateTime' => start_time.to_datetime.rfc3339},
        'end' => {'dateTime' => end_time.to_datetime.rfc3339},
        'summary' => name
      }.to_json
    end
  end
end
