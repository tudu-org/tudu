module Tudusched
  class ScheuleEntry
    attr_reader :name_time, :start, :end_time

    def initialize args={}
      name = args['name']
      start_time = args['start']
      end_time = args['end']
    end
  end

  class Task
    attr_reader :name, :time, :priority, :due

    def initialize args={}
      name = args['name']
      time = args['time']
      priority = args['priority']
      due = args['due']
    end
  end

  class Manifest
    attr_reader :start_time, :end_time, :schedule, :tasks

    def initialize args={}
      start_time |= args['start']
      end_time |= args['end']
      schedule |= args['schedule'].map{|e|
        ScheduleEntry.new e
      }
      tasks |= args['tasks'].map{|e|
        Task.new e
      }
    end
  end
end
