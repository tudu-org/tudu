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
      }.sort_by{|e|
        e.start_time
      }
      @tasks = args['tasks'].map{|e|
        Tudusched::Task.new e
      }
    end

    def free_entries
      cur_time = start_time
      entries = []

      schedule.each do |e|
        if e.start_time == cur_time
          next
        end

        entries << ScheduleEntry.new(:name => 'free',
          :start_time => cur_time, :end_time => e.start_time)
        cur_time = e.end_time
      end

      if cur_time != end_time
        entries << ScheduleEntry.new(:name => 'free',
          :start_time => cur_time, :end_time => end_time)
      end

      entries
    end

    def schedule_task
      # schedule a single task, then return.
      # We do this because after a task is scheduled
      # we must recompute the free_entries list, and instead
      # of doing this recursively we just call schedule_task
      # over and over while there are tasks to be scheduled

      tasks = tasks.sort_by{|e|
        e.priority
      }
    end

    def schedule_tasks
      while not tasks.empty?
        if not schedule_task
          # if it returns false that means a task failed
          # to be scheduled. We'll have to do something about it.
        end
      end
    end
  end
end
