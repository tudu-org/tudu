require 'date'

module Tudusched
  class ScheduleEntry
    attr_reader :name, :start_time, :end_time

    def initialize args={}
      @name = args['name']
      @start_time = DateTime.parse(args['start'])
      @end_time = DateTime.parse(args['end'])
    end
  end
end
