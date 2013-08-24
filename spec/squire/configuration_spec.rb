require 'spec_helper'

describe Squire::Configuration do
  context 'when configurating' do
    subject { Squire::Configuration::Entry }

    it 'should define simple configuration' do
      config = subject.new

      config.a = 1
      config.b   2

      config.a.should eql(1)
      config.b.should eql(2)
    end

    it 'should define nested configuration' do
      config = subject.new

      config.nested do |nested|
        nested.a = 1
      end

      config.nested do
        b 2
      end

      config.nested.a.should eql(1)
      config.nested.b.should eql(2)
    end

    it 'should fallback to parent configuration if not defined' do
      config = subject.new

      config.global = 1

      config.nested { |nested| nested.a = 1 }

      config.nested.global.should eql(1)
    end

    it 'should check if the value is set' do
      config = subject.new

      config.a = 1
      config.nested do |nested|
        nested.b = 2
      end

      config.a?.should        be_true
      config.nested.b?.should be_true
      config.nested.a?.should be_true
      config.global?.should   be_false
    end
  end

  context 'when including' do
    subject { Class.new { include Squire } }

    it 'should properly setup configuration for the object' do
      subject.config do |config|
        config.a = 1
      end

      subject.config.a.should eql(1)
    end
  end

  context 'when dumping' do
    subject { Squire::Configuration::Entry }

    it 'should provide hash dump' do
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

      config.to_hash.should eql({
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
end
