require 'rspec'

describe 'character sequences' do

  let (:lineValueCreator) { RegexValueCreator.new(/[\n\r]/, /[^[\n\r]]/) }
  let (:characterValueCreator) { CharacterValueCreator.new }

  it 'should handle character sequences' do
    charValues = ValueSequence.new().setCreator(characterValueCreator)
    charValues.addStringDataSource("abc123")
    cval = charValues.nextValue
    expect(cval.value).to eq('a')
    cval = charValues.nextValue
    expect(cval.value).to eq('b')
    cval = charValues.nextValue
    expect(cval.value).to eq('c')
    cval = charValues.nextValue
    expect(cval.value).to eq('1')
    cval = charValues.nextValue
    expect(cval.value).to eq('2')
    cval = charValues.nextValue
    expect(cval.value).to eq('3')
    cval = charValues.nextValue
    expect(cval).to eq(nil)
  end

  it 'should filter numbers by regex' do
    charValues = ValueSequence.new().setCreator(characterValueCreator)
    charValues.setFilter(RegexFilter.new(/\d/))
    charValues.addStringDataSource("abc123")
    cval = charValues.nextValue
    expect(cval.value).to eq('a')
    cval = charValues.nextValue
    expect(cval.value).to eq('b')
    cval = charValues.nextValue
    expect(cval.value).to eq('c')
    cval = charValues.nextValue
    expect(cval).to eq(nil)
  end

  it 'should filter letters by regex' do
    charValues = ValueSequence.new().setCreator(characterValueCreator)
    charValues.setFilter(RegexFilter.new(/[a-z]/))
    charValues.addStringDataSource("abc123")
    cval = charValues.nextValue
    expect(cval.value).to eq('1')
    cval = charValues.nextValue
    expect(cval.value).to eq('2')
    cval = charValues.nextValue
    expect(cval.value).to eq('3')
    cval = charValues.nextValue
    expect(cval).to eq(nil)
  end

  it 'should filter by lines and characters' do
    lineValues = ValueSequence.new().setCreator(lineValueCreator).setFilter(RegexFilter.new(/\A>/)).addFileDataSource("spec/fixtures/fakefasta.txt")
    charValues = ValueSequence.new().setCreator(characterValueCreator).setFilter(RegexFilter.new(/[^ACGT]/))
    sequenceValueCreator = SequenceValueCreator.new(lineValues, charValues)
    sequence = ValueSequence.new().setCreator(sequenceValueCreator)
    val = sequence.nextValue
    expect(val.value).to eq('A')
    val = sequence.nextValue
    expect(val.value).to eq('A')
    val = sequence.nextValue
    expect(val.value).to eq('C')
    val = sequence.nextValue
    expect(val.value).to eq('G')
    val = sequence.nextValue
    expect(val.value).to eq('T')
    val = sequence.nextValue
    expect(val.value).to eq('T')
    val = sequence.nextValue
    expect(val).to eq(nil)
  end
end