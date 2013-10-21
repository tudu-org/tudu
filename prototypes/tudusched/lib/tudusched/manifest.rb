require 'date'

require 'tudusched/task'
require 'tudusched/schedule_entry'

module Tudusched
  class Manifest
    attr_reader :start_time, :end_time, :schedule, :tasks

    def initialize args={}
      @start_time = DateTime.parse(args['start'])
      @end_time = DateTime.parse(args['end'])
      @schedule = args['schedule'].map{|e|
        Tudusched::ScheduleEntry.new e
      }
      @tasks = args['tasks'].map{|e|
        Tudusched::Task.new e
      }
    end
  end
end
