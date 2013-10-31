require 'spec_helper'

describe Squire::Parser::Hash do
  subject { Squire::Parser::Hash }

  it 'parses source hash' do
    source = { 'a' => 1, 'b' => 2, 'nested' => { 'c' => 2} }

    hash = subject.parse(source)

    expect(hash).to eql(source)
  end
end
