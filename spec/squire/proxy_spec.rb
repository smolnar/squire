require 'spec_helper'

class ProxiedConfiguration
  include Squire
end

class AnotherProxiedConfiguration
  include Squire
end

describe Squire::Proxy do
  subject { ProxiedConfiguration }

  let(:another) { AnotherProxiedConfiguration}

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

  it 'should properly setup separate proxies' do
    subject.squire.source    development: { a: 1, b: 2 }
    subject.squire.namespace :development

    another.squire.source    production: { a: 3, b: 4 }
    another.squire.namespace :production

    subject.squire.namespace.should eql(:development)
    subject.config.a.should eql(1)
    subject.config.b.should eql(2)

    another.squire.namespace.should eql(:production)
    another.config.a.should eql(3)
    another.config.b.should eql(4)
  end
end
