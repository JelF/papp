describe PApp::Application do
  class Dummy < described_class
    class << self
      attr_accessor :result
    end

    alias_key 'f', :foo
    alias_key 'b', :bar

    def initialize(*args)
      @args = args
    end

    def run
      self.class.result = @args
    end
  end

  it 'parses params' do
    Dummy.run! %w[-fb foo foo --baz --xxx something -- -ruby-is-cool=yes]
    expect(Dummy.result).to(eq(['foo', '-ruby-is-cool=yes', foo: 1,
                                bar: 'foo', baz: 1, xxx: 'something']))
      
  end
end