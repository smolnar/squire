require 'spec_helper'

class ProxiedConfiguration
  include Squire
end

describe Squire::Proxy do
  subject { ProxiedConfiguration }

  it 'should properly setup proxied configuration' do
    subject.squire.source    development: { a: 1, b: 2 }
    subject.squire.namespace :development

    subject.config do |config|
      config.c = 3
    end

    subject.config.a.should eql(1)
    subject.config.b.should eql(2)
    subject.config.c.should eql(3)

    expect { subject.a }.to raise_error(NoMethodError)
  end
end
