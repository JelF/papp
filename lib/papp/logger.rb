module PApp
  # Defines a simple logger
  class Logger
    LEVELS = {
      1 => :error,
      2 => :warn,
      3 => :info,
      4 => :debug,
    }
    
    attr_accessor :verbosity, :output

    LEVELS.each do |v, level|
      define_method(level) do |*args|
        log!(v, *args) if v <= verbosity
      end
    end

    def initialize(output, verbosity)
      self.verbosity = if verbosity.is_a?(Numeric)
                         verbosity
                       else
                         LEVELS.invert[verbosity]
                       end

      self.output = output.respond_to?(:puts) ? output : File.open(output, 'w')
    end

    def log!(v, *args)
      args = args.flat_map { |x| x.to_s.split("\n") }
      header = "--- #{LEVELS[v].to_s.upcase} #{Time.now}"
      args.each do |arg|
        output.puts("#{header}: #{arg}")
      end
    end
  end
end
