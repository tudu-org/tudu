require 'date'

module Tudusched
  class Task
    attr_reader :name, :time, :priority, :due

    def initialize args={}
      @name = args['name']
      @time = args['time']
      @priority = args['priority']
      @due = DateTime.parse(args['due'])
    end
  end
end
