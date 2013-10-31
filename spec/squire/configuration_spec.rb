require 'spec_helper'

describe Squire::Configuration do
  let(:hash) {
    {
      defaults: {
        nested: {
          b: 3,
          d: true,
          c: 4
        }
      },
      development: {
        a: 1,
        nested: {
          b: 2,
          d: false
        }
      },
      production: {
        a: 3,
        nested: {
          b: 4
        }
      }
    }
  }

  describe '#source' do
    it 'properly sets hash as source' do
      subject.source hash

      expect(subject.source).to eql(hash)
    end

    it 'properly sets yaml sa a source' do
      subject.source 'config.yml'

      expect(subject.source).to eql('config.yml')
      expect(subject.type).to   eql(:yml)
    end
  end

  describe '#namespace' do
    it 'properly sets namespace' do
      subject.source    hash
      subject.namespace :development

      expect(subject.settings.a).to eql(1)
      expect(subject.namespace).to eql(:development)

      expect { subject.settings.development }.to raise_exception(Squire::MissingSettingError)
    end

    it 'properly handles runtime changing of namespaces' do
      subject.source    hash
      subject.namespace :development

      expect(subject.settings.a).to eql(1)

      subject.namespace :production

      expect(subject.settings.a).to eql(3)
    end

    it 'handles base namespace overriding' do
      subject.source    hash
      subject.namespace :development, base: :defaults

      expect(subject.settings.a).to        eql(1)
      expect(subject.settings.nested.b).to eql(2) # from development.nested.b
      expect(subject.settings.nested.d).to be_false # from development.nested.d
      expect(subject.settings.nested.c).to eql(4) # from defaults.nested.c

      subject.source    hash
      subject.namespace :production, base: :defaults

      expect(subject.settings.a).to        eql(3)
      expect(subject.settings.nested.b).to eql(4) # from development.nested.b
      expect(subject.settings.nested.d).to be_true # from development.nested.d
    end
  end

  describe '#setup' do
    let(:path)    { '/path/to/file.yml'}
    let(:factory) { double(:factory) }
    let(:parser)  { double(:parser) }

    it 'sets up basic settings from hash' do
      subject.source(hash)

      expect(factory).to receive(:of).with(:hash).and_return(parser)
      expect(parser).to receive(:parse).with(hash).and_return(hash)

      stub_const('Squire::Parser', factory)

      settings = subject.setup

      expect(settings.to_hash).to eql(hash)
    end

    it 'sets up basic settings yml' do
      expect(factory).to receive(:of).with(:yml).and_return(parser)
      expect(parser).to receive(:parse).with(path).and_return(hash)

      stub_const('Squire::Parser', factory)

      subject.source(path)

      settings = subject.settings

      expect(settings.development.a).to        eql(1)
      expect(settings.development.nested.b).to eql(2)
    end

    it 'does not set up source with unknown filetype' do
      subject.source(path, type: :bogus)

      expect { subject.setup }.to raise_error Squire::UndefinedParserError
    end
  end
end
