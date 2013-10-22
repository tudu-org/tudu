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
        Tudusched::ScheduleEntry.initialize_from_hash e
      }.sort_by{|e|
        e.start_time
      }
      @tasks = args['tasks'].map{|e|
        Tudusched::Task.new e
      }
    end

    def resort_schedule
      @schedule = @schedule.sort_by{|e|
        e.start_time
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

      free_entries.each do |free_entry|
        @tasks = @tasks.sort_by{|e|
          e.priority free_entry.start_time
        }.reverse

        picked_task = nil
        @tasks.each do |task|
          if task.time <= free_entry.length
            @schedule << task.to_schedule_entry(free_entry.start_time)
            resort_schedule
            picked_task = task
            break
          end
        end

        if picked_task
          @tasks.delete picked_task
          return true
        end
      end

      # if we get to this point it means we failed
      # to schedule a task, so we should return
      # false to denote that we've failed
      return false
    end

    def schedule_tasks
      while not tasks.empty?
        if not schedule_task
          return false
        end
      end

      return true
    end
  end
end
