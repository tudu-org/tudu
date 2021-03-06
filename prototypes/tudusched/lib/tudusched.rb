require 'json'
require 'optparse'
require 'google/api_client'

require 'tudusched/manifest'

module Tudusched
  class << self
    def load_manifest_file filename
      h = JSON.parse(IO.read(filename))

      Manifest.new h
    end

    def get_google_client
      client = Google::APIClient.new(
        :application_name => 'tudusched',
        :application_version => '1.0.0'
        )

      client.authorization.client_id = '1076895517677.apps.googleusercontent.com'
      client.authorization.client_secret = 'GMQpEKkIGxF2lSVF1AqUOKNf'
      client.authorization.redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'

      client.authorization.scope = 'https://www.googleapis.com/auth/calendar'

      redirect_uri = client.authorization.authorization_uri

      print "Please navigate your browser to #{redirect_uri} and paste your result in the terminal\n"
      print "Result: "

      client.authorization.code = gets.chomp
      #client.authorization.access_token = client.authorization.code
      client.authorization.fetch_access_token!

      client
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

        opts.on("-g", "--google",
          "use the google calendar API to get the schedule list") do
          options[:google] = true
        end
      end.parse!

      print "Using input file #{options[:input]}\n"
      print "Using output file #{options[:output]}\n"

      if options[:input]
        m = load_manifest_file options[:input]
      end

      if options[:google]
        client = get_google_client
        calendar = client.discovered_api('calendar', 'v3')
        if not options[:input]
          events = client.execute(:api_method => calendar.events.list,
                                   :parameters => {'calendarId' => 'primary'})

          p events
        else
          m.load_from_google_calendar client
        end
      end

      if options[:free_entries]
        IO.write(options[:output], m.free_entries.map{|e| e.to_h}.to_json)
        return
      end

      if options[:output] or options[:google]
        m.schedule_tasks
      end

      if options[:output]
        IO.write(options[:output], m.to_h.to_json)
      end

      if options[:google]
        m.write_scheduled_tasks_to_google_calendar client
      end
    end
  end
end
