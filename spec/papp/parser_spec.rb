describe PApp::Parser do
  before { described_class.alias_key 'f', :foo }
  before { described_class.alias_key 'b', :bar }

  EXPECTATIONS = {
    %w() => [],
    %w(foo) => ['foo'],
    %w(foo bar) => %w(foo bar),
    %w(--foo bar) => [foo: 'bar'],
    %w(--foo=bar) => [foo: 'bar'],
    %w(--foo --bar baz) => [foo: 1, bar: 'baz'],
    %w(-- --foo bar) => ['--foo', 'bar'],
    %w(-f) => [foo: 1],
    %w(-f bar) => [foo: 'bar'],
    %w(-fb baz) => [foo: 1, bar: 'baz']
  }

  EXPECTATIONS.each do |key, value|
    specify "#{key} => #{value}" do
      expect(described_class.new(key).extract_options!).to eq value
    end
  end
end
