require 'spec_helper'

class Configuration
  include Squire::Base
end

describe Squire::Base do
  subject { Configuration }

  before :each do
    subject.squire.reload!
  end

  it 'properly sets up base configuration' do
    subject.squire.source    development: { a: 1, b: 2 }
    subject.squire.namespace :development

    subject.config do |config|
      config.c = 3
    end

    expect(subject.config.a).to eql(1)
    expect(subject.config.b).to  eql(2)
    expect(subject.config.c).to eql(3)

    expect(subject.a).to eql(1)
    expect(subject.b).to eql(2)
    expect(subject.c).to eql(3)

    expect { subject.d }.to raise_error(Squire::MissingSettingError)
  end

  it 'properly delegates keys' do
    subject.squire.source    test: { a: 1, b: 2 }
    subject.squire.namespace :test

    expect(subject.a).to eql(1)
    expect(subject.b).to eql(2)

    expect { subject.c }.to raise_error(Squire::MissingSettingError, /Missing setting 'c' in 'test'/)
  end
end
