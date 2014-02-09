require 'spec_helper'

# :TODO: Refactor redundant usage of subject

describe Squire::Settings do
  subject { Squire::Settings }

  it 'defines simple configuration' do
    config = subject.new

    config.a = 1
    config.b = 2

    expect(config.a).to eql(1)
    expect(config.b).to eql(2)
  end

  it 'defines nested configuration' do
    config = subject.new

    config.nested do |nested|
      nested.a = 1
    end

    config.nested do |nested|
      nested.b = 2
    end

    expect(config.nested.a).to eql(1)
    expect(config.nested.b).to eql(2)
  end

  it 'checks if the value is set' do
    config = subject.new

    config.a = 1
    config.nested do |nested|
      nested.b = 2
    end

    expect(config.a?).to        be_true
    expect(config.nested.b?).to be_true
    expect(config.nested.a?).to be_false
    expect(config.global?).to   be_false
  end

  it 'caches value after setting' do
    config = subject.new

    config.a = 1
    config.nested do |nested|
      nested.b = 2
    end

    expect(config).to respond_to(:a)
    expect(config.nested).to respond_to(:b)
  end

  it 'raises error when setting is missing' do
    config = subject.new

    expect { config.a }.to raise_error(Squire::MissingSettingError, /Missing setting 'a'/)
  end

  it 'behaves as plain object' do
    config = subject.new

    config.puts = 1
    config.test do |nested|
      nested.a = 2
    end

    expect(config.puts).to eql(1)
    expect(config.test.a).to eql(2)
  end

  describe '#to_s' do
    it 'converts settings to string representation' do
      config = subject.new

      config.a = 1
      config.b = 2

      config.nested do |nested|
        nested.c = 3
      end

      expect(config.to_s).to eql('#<Squire::Settings a=1, b=2, nested=#<Squire::Settings c=3>>')
    end
  end

  describe '#[]' do
    it 'allows accesing keys in hash manner' do
      config = subject.new

      config.a = 1

      expect(config[:a]).to  eql(1)
      expect(config['a']).to eql(1)
      expect(config[:b]).to  be_nil
    end
  end

  describe '#to_hash' do
    it 'properly dumps settings as hash' do
      config = subject.new

      config.a = 1
      config.b = 2

      config.nested do |nested|
        nested.c = 3
        nested.d = 4

        nested.other do |other|
          other.e = 5
        end
      end

      expect(config.to_hash).to eql({
        a: 1,
        b: 2,
        nested: {
          c: 3,
          d: 4,
          other: {
            e: 5
          }
        }
      })
    end
  end

  describe '.from_hash' do
    it 'parses settings from hash' do
      settings = subject.from_hash({
        a: 1,
        b: 2,
        nested: {
          c: 3,
          d: 4,
          other: {
            e: 5
          }
        }
      })

      expect(settings.a).to eql(1)
      expect(settings.b).to eql(2)

      settings.nested do |nested|
        expect(nested.c).to eql(3)
        expect(nested.d).to eql(4)

        nested.other do |other|
          expect(other.e).to eql(5)
        end
      end
    end
  end
end
