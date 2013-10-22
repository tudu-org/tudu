require 'json'
require 'optparse'

require 'tudusched/scheduler'
require 'tudusched/manifest'

module Tudusched
  class << self
    def load_manifest_file filename
      h = JSON.parse(IO.read(filename))

      Manifest.new h
    end

    def cli
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: tudusched [options]"

        opts.on("-i", "--input MANIFEST",
          "The name of the input manifest json file") do |input|
          options[:input] = input
        end

        opts.on("-o", "--output OUT_MANIFEST",
          "the name of the file to write the output manifest to") do |output|
          options[:output] = output
        end

        opts.on("-d", "--free-entries",
          "print the free entries we generate from the given schedule") do
          options[:free_entries] = true
        end
      end.parse!

      print "Using input file #{options[:input]}\n"
      print "Using output file #{options[:output]}\n"

      m = load_manifest_file options[:input]

      if options[:free_entries]
        IO.write(options[:output], m.free_entries.map{|e| e.to_h}.to_json)
        return
      end

      m.schedule_tasks

      IO.write(options[:output], m.to_h.to_json)
    end
  end
end
