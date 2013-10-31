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

  it 'properly sets up proxied configuration' do
    subject.squire.source    development: { a: 1, b: 2 }
    subject.squire.namespace :development

    subject.config do |config|
      config.c = 3
    end

    expect(subject.config.a).to eql(1)
    expect(subject.config.b).to eql(2)
    expect(subject.config.c).to eql(3)

    expect { subject.a }.to raise_error(NoMethodError)
  end

  it 'properly sets up separate proxies' do
    subject.squire.source    development: { a: 1, b: 2 }
    subject.squire.namespace :development

    another.squire.source    production: { a: 3, b: 4 }
    another.squire.namespace :production

    expect(subject.squire.namespace).to eql(:development)
    expect(subject.config.a).to eql(1)
    expect(subject.config.b).to eql(2)

    expect(another.squire.namespace).to eql(:production)
    expect(another.config.a).to eql(3)
    expect(another.config.b).to eql(4)
  end
end
