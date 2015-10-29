require 'papp/parser'
require 'papp/logger'

module PApp
  # This is an application superclass
  # You should inherit it
  # A good idea is to save instance in a constant
  class Application
    # builds an applictaqion from ARGV
    def self.build!(args = ARGV)
      options = Parser.new(args).extract_options!
      new(*options)
    end

    # defines key alias
    # ==== Examples
    #   alias_key 'f', :foo
    #   # -f 123 => { foo: 123 }
    #   # --f=123 => { foo: 123 }
    def self.alias_key(key, option)
      Parser.alias_key(key, option)
    end

    alias_key :v, :verbose
    attr_accessor :logger

    # `initialize` will receive all params, loaded from ARGV
    def initialize(*, verbose: '1', log_file: STDERR, **)
      v = (verbose =~ /\d+/) ? verbose.to_i : verbose.to_sym
      self.logger = Logger.new(log_file, v)
    end
  end
end
