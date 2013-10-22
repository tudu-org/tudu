require 'date'

module Tudusched
  class Task
    attr_reader :name, :time, :importance, :due

    def add_priority_fn &block
      @priority_fns ||= []
      @priority_fns << block
    end

    def initialize args={}
      @name = args['name']
      @time = args['time']
      @priority = args['importance']
      @due = DateTime.parse(args['due'])

      add_priority_fn do |cur_time|
        # funciton for "importance"
        importance
      end

      add_priority_fn do |cur_time|
        # function for "time-til due-"
        time_til_due = due - cur_time
        # time_til_due is in days, so we'll
        # convert it to seconds first just so
        # we can use the function from 
        # the clojure implementation
        time_til_due = time_til_due * 24 * 60 * 60
        if time_til_due == 0
          # if this is the case then this should have
          # a very high priority.  How high? well for
          # now we'll just return a very big number...
          # this should be fixed in the future
          next 100000000000
        end

        # otherwise, use our little formula
        172800 / time_til_due * 4
      end

      add_priority_fn do |cur_time|
        # function for "time-to-finish".
        # currently has zero weight
        0
      end
    end


    def priority cur_time
      @priority_fns.reduce(0){|memo, e|
        memo + e.call(cur_time)
      }
    end
  end
end
