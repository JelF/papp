describe PApp::Logger do
  subject { "" }
  let(:io) { StringIO.new(subject, 'w') }
  let(:logger) { described_class.new(io, verbosity) }
  let(:verbosity) { :warn }

  describe 'it logs error' do
    before { logger.error 'gg' }
    it { is_expected.to match /\A--- ERROR .+ gg\n\z/ }
  end

  describe 'it logs warn' do
    before { logger.warn 'gg' }
    it { is_expected.to match /\A--- WARN/ }
  end

  describe 'it does not log debug' do
    before { logger.debug 'gg' }
    it { is_expected.to be_empty }
  end
end