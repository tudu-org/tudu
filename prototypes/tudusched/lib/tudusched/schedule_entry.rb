module Tudusched
  class ScheduleEntry
    attr_reader :name_time, :start, :end_time

    def initialize args={}
      name = args['name']
      start_time = args['start']
      end_time = args['end']
    end
  end
end
