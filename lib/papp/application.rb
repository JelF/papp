require 'papp/parser'
require 'papp/logger'

module PApp
  class Application
    def self.run!(args = ARGV)
      options = Parser.new(args).extract_options!
      new(*options).run
    end

    def self.alias_key(key, option)
      Parser.alias_key(key, option)
    end

    alias_key :v, :verbose
    attr_accessor :logger

    def initialize(*, verbose: 1, log_file: STDOUT, **)
      self.logger = Logger.new(log_file, verbose)
    end

    def run
      raise NotImplementedError
    end
  end
end