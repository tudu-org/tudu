require 'date'
require 'json'

require 'tudusched/task'
require 'tudusched/schedule_entry'

module Tudusched
  class Manifest
    attr_reader :start_time, :end_time, :schedule, :tasks

    def to_h
      out = {}
      out[:start_time] = start_time
      out[:end_time] = end_time
      out[:schedule] = schedule.map{|e|
        e.to_h
      }
      out[:tasks] = tasks.map{|e|
        e.to_h
      }

      out
    end

    def scheduled_tasks
      schedule.select{|e|
        e.scheduled
      }
    end

    def remove_irrelevant_schedule_entries
      @schedule = schedule.select{|e|
        e.end_time > start_time and e.start_time < end_time
      }
    end

    def initialize args={}
      @start_time = Time.parse(args['start'])
      @end_time = Time.parse(args['end'])
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
        if e.start_time <= cur_time
          cur_time = e.end_time
          next
        end

        free_end = e.end_time
        if free_end > end_time
          free_end = end_time
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

    def load_from_google_calendar client
      calendar = client.discovered_api('calendar', 'v3')
      events = client.execute(:api_method => calendar.events.list,
                              :parameters => {'calendarId' => 'primary',
                                              #'timeMin' => start_time,
                                              #'timeMax' => end_time,
                                              'singleEvents' => true})
      loop do
        events.data.items.each do |gcal_event|
          if not gcal_event.start['dateTime']
            next
          end
          start_time = gcal_event.start.dateTime
          end_time = gcal_event.end.dateTime
          #puts "found event " + gcal_event.summary
          @schedule << ScheduleEntry.new(:name => gcal_event.summary ,
            :start_time => start_time,
            :end_time => end_time)
        end

        break unless events.next_page_token
        events = client.execute(events.next_page)
      end
    end

    def write_scheduled_tasks_to_google_calendar client, calendar_name="tudu"
      calendar = client.discovered_api('calendar', 'v3')
      events = scheduled_tasks

      # first we need to find the calendar id of the tudu calendar
      cal_list = client.execute(:api_method => calendar.calendar_list.list)
      c = cal_list.data.items.find{|e|
        e.summary == calendar_name
      }

      if not c
        puts "The " + calendar_name + " doesn't exist for this user! Exiting."
        return
      end

      calendar_id = c.id

      # finally iterate through the events adding them to the calendar
      events.each do |e|
        res = client.execute(:api_method => calendar.events.insert,
                       :parameters => {'calendarId' => calendar_id},
                       :body => e.to_gcal_entry,
                       :headers => {'Content-Type' => 'application/json'})
        p res
      end
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
      remove_irrelevant_schedule_entries
      while not tasks.empty?
        if not schedule_task
          return false
        end
      end

      return true
    end
  end
end
