require 'rspec'
require_relative '../lib/value_sequence'

describe 'Value sequence' do

  def check(fileValue)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(line2)
    expect(fileValue.nextValue.value).to eq(line3)
    expect(fileValue.nextValue.value).to eq(line4)
    expect(fileValue.nextValue.value).to eq(line5)
  end

  def check123(seq, dataId)
    seqValue = seq.nextValue
    expect(seqValue.value).to eq(line1)
    expect(seqValue.dataId).to eq(dataId)
    seqValue = seq.nextValue
    expect(seqValue.value).to eq(line2)
    expect(seqValue.dataId).to eq(dataId)
    seqValue = seq.nextValue
    expect(seqValue.value).to eq(line3)
    expect(seqValue.dataId).to eq(dataId)
  end

  let (:lineValueCreator) { RegexValueCreator.new(/[\n\r]/, /[^[\n\r]]/) }
  let (:wordValueCreator) { RegexValueCreator.new(/[^[\w]]/, /[\w]/) }
  let (:line1) { "line1" }
  let (:line2) { "line2" }
  let (:line3) { "line3" }
  let (:line4) { "this is a test" }
  let (:line5) { "final line" }

  let (:regexFilter) { RegexFilter.new(/\w*(\/\/)+|\w*#/) }
  let (:lastfilterline) { "end line" }

  it 'should create sequence of values from a file' do
    fileValue = ValueSequence.new().setCreator(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/testdata.txt")
    check(fileValue)
    fileValue = ValueSequence.new().setCreator(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/testdata1.txt")
    check(fileValue)
    fileValue = ValueSequence.new().setCreator(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/testdata2.txt")
    check(fileValue)
  end

  it 'should filter out values' do
    fileValue = ValueSequence.new().setCreator(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/filterdata.txt")
    fileValue.setFilter(regexFilter)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(lastfilterline)
  end

  it 'should handle strings same as file' do
    stringValue = ValueSequence.new().setCreator(lineValueCreator)
    stringValue.addStringDataSource("#{line1}\n#{line2}\r\n#{line3}\r\r\n\n#{line4}\r#{line5}")
    check(stringValue)
  end

  it 'should handle multiple string data sources' do
    mValue = ValueSequence.new().setCreator(lineValueCreator)
    mValue.addStringDataSource("#{line1}")
    mValue.addStringDataSource("#{line2}\n\r#{line3}")
    mValue.addStringDataSource("#{line4}")
    locValue = mValue.nextValue
    expect(locValue.value).to eq(line1)
    expect(locValue.location).to eq(0)
    expect(locValue.dataId).to eq(0)
    locValue = mValue.nextValue
    expect(locValue.value).to eq(line2)
    expect(locValue.location).to eq(0)
    expect(locValue.dataId).to eq(1)
    locValue = mValue.nextValue
    expect(locValue.value).to eq(line3)
    expect(locValue.location).to eq(line2.length + 2)
    expect(locValue.dataId).to eq(1)
    locValue = mValue.nextValue
    expect(locValue.value).to eq(line4)
    expect(locValue.location).to eq(0)
    expect(locValue.dataId).to eq(2)
  end

  it 'should handle multiple file data sources' do
    fileValue = ValueSequence.new().setCreator(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/line123.txt")
    fileValue.addFileDataSource("spec/fixtures/line123.txt")
    fileValue.addFileDataSource("spec/fixtures/line123.txt")
    check123(fileValue, 0)
    check123(fileValue, 1)
    check123(fileValue, 2)
  end

  it 'should be able to mix file and string data sources' do
    valueSequence = ValueSequence.new().setCreator(lineValueCreator)
    valueSequence.addFileDataSource("spec/fixtures/line123.txt")
    valueSequence.addStringDataSource("line1\r\nline2\n\rline3")
    valueSequence.addStringDataSource("blahblah")
    check123(valueSequence, 0)
    check123(valueSequence, 1)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("blahblah")
    expect(seqVal.dataId).to eq(2)
  end

  it 'should support word sequences' do
    valueSequence = ValueSequence.new().setCreator(wordValueCreator)
    valueSequence.addStringDataSource("  blah blah \n\rtest one               two")
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("blah")
    expect(seqVal.location).to eq(2)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("blah")
    expect(seqVal.location).to eq(7)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("test")
    expect(seqVal.location).to eq(14)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("one")
    expect(seqVal.location).to eq(19)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("two")
    expect(seqVal.location).to eq(37)
    expect(seqVal.dataId).to eq(0)
  end

  it 'should allow one ValueSequence to be data source for another' do
    lineValueSequence = ValueSequence.new().setCreator(lineValueCreator)
    lineValueSequence.addFileDataSource("spec/fixtures/wordlines.txt")
    wordValueSequence = ValueSequence.new().setCreator(wordValueCreator)
    sequenceValueCreator = SequenceValueCreator.new(lineValueSequence, wordValueSequence)
    sequence = ValueSequence.new().setCreator(sequenceValueCreator)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("one")
    expect(seqVal.location).to eq(0)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("two")
    expect(seqVal.location).to eq(4)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("three")
    expect(seqVal.location).to eq(8)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("four")
    expect(seqVal.location).to eq(14)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("five")
    expect(seqVal.location).to eq(19)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("six")
    expect(seqVal.location).to eq(24)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("seven")
    expect(seqVal.location).to eq(28)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("eight")
    expect(seqVal.location).to eq(34)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("nine")
    expect(seqVal.location).to eq(40)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("ten")
    expect(seqVal.location).to eq(45)
    seqVal = sequence.nextValue
    expect(seqVal.value).to eq("eleven")
    expect(seqVal.location).to eq(50)
    seqVal = sequence.nextValue
    expect(seqVal).to eq(nil)
    seqVal = sequence.nextValue
    expect(seqVal).to eq(nil)
    seqVal = sequence.nextValue
    expect(seqVal).to eq(nil)
  end

  it 'should allow multiple files as source for another' do
    lineValueSequence = ValueSequence.new().setCreator(lineValueCreator)
    lineValueSequence.addFileDataSource("spec/fixtures/line123.txt")
    lineValueSequence.addFileDataSource("spec/fixtures/line123.txt")
    wordValueSequence = ValueSequence.new().setCreator(wordValueCreator)
    sequenceValueCreator = SequenceValueCreator.new(lineValueSequence, wordValueSequence)
    sequence = ValueSequence.new().setCreator(sequenceValueCreator)
    check123(sequence, 0)
    check123(sequence, 1)
    seqVal = sequence.nextValue
    expect(seqVal).to eq(nil)
  end

  it 'should transform strings into numbers' do
    lineValueSequence = ValueSequence.new().setCreator(lineValueCreator).addTransformer(CaseTransformer.new(:down))
    lineValueSequence.addFileDataSource("spec/fixtures/wordlines.txt")
    lineValueSequence.addFileDataSource("spec/fixtures/wordlines2.txt")
    wordValueSequence = ValueSequence.new().setCreator(wordValueCreator)
    sequenceValueCreator = SequenceValueCreator.new(lineValueSequence, wordValueSequence)
    sequence = ValueSequence.new().setCreator(sequenceValueCreator)
    sequence.addTransformer(StringToNumber.new)
    (1..11).each do |val|
      seqVal = sequence.nextValue
      expect(seqVal.value).to eq(val)
      expect(seqVal.dataId).to eq(0)
    end
    11.downto(1).each do |val|
      seqVal = sequence.nextValue
      expect(seqVal.value).to eq(val)
      expect(seqVal.dataId).to eq(1)
    end
    seqVal = sequence.nextValue
    expect(seqVal).to eq(nil)
  end
end

