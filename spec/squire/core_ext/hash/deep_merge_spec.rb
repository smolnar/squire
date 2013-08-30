require 'spec_helper'

describe Hash do
  describe '#deep_merge' do
    let(:a) {{ a: 1, b: 2, c: 3, nested: { a: 1 }}}
    let(:b) {{ a: 1, c: 3, d: 4, nested: { a: 2, b: 3 }}}

    it 'should merge hashes deeply' do
      merge = { a: 1, b: 2, c: 3, d: 4, nested: { a: 2, b: 3 }}

      a.deep_merge(b).should eql(merge)
    end

    it 'should merge hashes deeply with block' do
      merge = { a: [:a, 1, 1], b: 2, c: [:c, 3, 3], d: 4, nested: { a: [:a, 1, 2], b: 3 }}

      (a.deep_merge(b) { |key, old, new| [key, old, new] }).should eql(merge)
    end
  end
end
