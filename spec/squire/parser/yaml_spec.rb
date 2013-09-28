require 'spec_helper'

describe Squire::Parser::YAML do
  subject { described_class }

  it 'should parse yaml file from path' do
    hash = subject.parse(fixture('basic.yml').path)

    hash.should eql(
      'defaults' => nil,
      'development' => {
        'a' => 1,
        'nested' => {
          'b' => 2
        }
      }
    )
  end
end
