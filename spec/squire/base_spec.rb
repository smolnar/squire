require 'spec_helper'

class Configuration
  include Squire::Base
end

describe Squire::Base do
  subject { Configuration }

  before :each do
    subject.squire.reload!
  end

  it 'should properly setup base configuration' do
    subject.squire.source    development: { a: 1, b: 2 }
    subject.squire.namespace :development

    subject.config do |config|
      config.c = 3
    end

    subject.config.a.should eql(1)
    subject.config.b.should eql(2)
    subject.config.c.should eql(3)

    subject.a.should eql(1)
    subject.b.should eql(2)
    subject.c.should eql(3)

    expect { subject.d }.to raise_error(Squire::MissingSettingError)
  end

  it 'should properly delegate keys' do
    subject.squire.source    test: { a: 1, b: 2 }
    subject.squire.namespace :test

    subject.a.should eql(1)
    subject.b.should eql(2)
  end
end
