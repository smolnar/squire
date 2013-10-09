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
    it 'should properly set hash as source' do
      subject.source hash

      subject.source.should eql(hash)
    end

    it 'should properly set yaml sa a source' do
      subject.source 'config.yml'

      subject.source.should eql('config.yml')
      subject.type.should   eql(:yml)
    end
  end

  describe '#namespace' do
    it 'should properly set namespace' do
      subject.source    hash
      subject.namespace :development

      subject.settings.a.should  eql(1)
      subject.namespace.should   eql(:development)

      expect { subject.settings.development }.to raise_exception(Squire::MissingSettingError)
    end

    it 'should properly handle runtime changing of namespaces' do
      subject.source    hash
      subject.namespace :development

      subject.settings.a.should eql(1)

      subject.namespace :production

      subject.settings.a.should eql(3)
    end

    it 'should handle base namespace overriding' do
      subject.source    hash
      subject.namespace :development, base: :defaults

      subject.settings.a.should eql(1)
      subject.settings.nested.b.should eql(2) # from development.nested.b
      subject.settings.nested.d.should be_false # from development.nested.d
      subject.settings.nested.c.should eql(4) # from defaults.nested.c

      subject.source    hash
      subject.namespace :production, base: :defaults

      subject.settings.a.should eql(3)
      subject.settings.nested.b.should eql(4) # from development.nested.b
      subject.settings.nested.d.should be_true # from development.nested.d
    end
  end

  describe '#setup' do
    let(:path) { '/path/to/file.yml'}
    let(:factory) { double(:factory) }
    let(:parser)  { double(:parser) }

    it 'should setup basic settings from hash' do
      subject.source(hash)

      factory.should_receive(:of).with(:hash).and_return(parser)
      parser.should_receive(:parse).with(hash).and_return(hash)

      stub_const('Squire::Parser', factory)

      settings = subject.setup

      settings.to_hash.should eql(hash)
    end

    it 'should setup basic settings yml' do
      factory.should_receive(:of).with(:yml).and_return(parser)
      parser.should_receive(:parse).with(path).and_return(hash)

      stub_const('Squire::Parser', factory)

      subject.source(path)

      settings = subject.settings

      settings.development.a.should        eql(1)
      settings.development.nested.b.should eql(2)
    end

    it 'should not setup source with unknown filetype' do
      subject.source(path, type: :bogus)

      expect { subject.setup }.to raise_error Squire::UndefinedParserError
    end
  end
end
