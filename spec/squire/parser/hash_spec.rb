require 'spec_helper'

describe Squire::Parser::Hash do
  subject { Squire::Parser::Hash }

  it 'should parse source hash' do
    hash = subject.parse('a' => 1, 'b' => 2, 'nested' => { 'c' => 2})

    hash.should eql({
      a: 1,
      b: 2,
      nested: {
        c: 2
      }
    })
  end
end
