module PApp
  # Parses generic param lists and extracts options
  class Parser
    def self.alias_key(key, value)
      aliases[convert_key(key)] = convert_key(value)
    end

    def self.aliases
      @aliases ||= {}
    end

    def self.convert_key(key)
      key.to_s.tr('-', '_').to_sym
    end

    def initialize(args)
      self.args = args.dup
      self.options = []
      self.keys = Hash.new(0)
    end

    def extract_options!
      extract_option! while args.any?

      options << keys if keys.any?
      options
    end

    private

    attr_accessor :args, :options, :keys

    # FIXME[WANTHELP]: ABC size should be reduced without readablity loss
    # FIXME[WANTHELP]: method size should be reduced without readablity loss
    # run bin/rubocop to see it's values
    def extract_option!
      case args[0]
      when /\A-[^-]./
        bump_key!(args[0].slice!(1))
      when /\A-[^-]\z/
        try_add_kv!(args[0][1])
      when /\A--(.+?)=(.+)/
        add_key!(*Regexp.last_match.values_at(1, 2))
        args.shift
      when /\A--./
        try_add_kv!(args[0][2..-1])
      when '--'
        args.shift
        self.options += args
        self.args = []
      else
        options << args.shift
      end
    end

    def try_add_kv!(key)
      args.shift
      if value?(args[0])
        add_key!(key, args.shift)
      else
        bump_key!(key)
      end
    end

    def value?(arg)
      return unless arg
      arg[0] != '-'
    end

    def bump_key!(key)
      keys[real_key(key)] += 1
    end

    def add_key!(key, value)
      keys[real_key(key)] = value
    end

    def real_key(key)
      key = self.class.convert_key(key)
      self.class.aliases.fetch(key, key)
    end
  end
end
