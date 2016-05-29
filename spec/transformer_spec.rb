require 'rspec'

require_relative '../lib/value_sequence'

describe 'transforming values' do

  let (:transformer) { Transformer.new }

  it 'should change case' do
    transformer.add(CaseTransformer.new(:down))
    expect(transformer.transform("A")).to eq("a")
  end

  it 'should upcase' do
    transformer.add(CaseTransformer.new(:up))
    expect(transformer.transform("asdf bob")).to eq("ASDF BOB")
  end

  it 'should change strings to numbers' do
    transformer.add(StringToNumber.new)
    expect(transformer.transform("one")).to eq(1)
    expect(transformer.transform("two")).to eq(2)
    expect(transformer.transform("asdf")).to eq(3)
    expect(transformer.transform("two")).to eq(2)
    expect(transformer.transform("one")).to eq(1)
  end

  it 'should chain sequence of transformers' do
    transformer.add(CaseTransformer.new(:up))
    transformer.add(StringToNumber.new)
    expect(transformer.transform("one")).to eq(1)
    expect(transformer.transform("ONE")).to eq(1)
    expect(transformer.transform("asDF")).to eq(2)
    expect(transformer.transform("xx")).to eq(3)
    expect(transformer.transform("ASdf")).to eq(2)
  end
end