require 'tudusched/scheduler'
require 'json'
require 'tudusched/manifest'

module Tudusched
  class << self
    def info
      return "this is just a test!"
    end

    def schedule manifest

    end

    def load_manifest_file filename
      h = JSON.parse(IO.read(filename))

      Manifest.new h
    end
  end
end
