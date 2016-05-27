require 'rspec'
require_relative '../lib/creator/regex_value_creator'
require_relative '../lib/value/value_sequence'
require_relative '../lib/filter/regex_filter'

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
    fileValue = ValueSequence.new(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/testdata.txt")
    check(fileValue)
    fileValue = ValueSequence.new(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/testdata1.txt")
    check(fileValue)
    fileValue = ValueSequence.new(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/testdata2.txt")
    check(fileValue)
  end

  it 'should filter out values' do
    fileValue = ValueSequence.new(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/filterdata.txt")
    fileValue.addFilter(regexFilter)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(lastfilterline)
  end

  it 'should handle strings same as file' do
    stringValue = ValueSequence.new(lineValueCreator)
    stringValue.addStringDataSource("#{line1}\n#{line2}\r\n#{line3}\r\r\n\n#{line4}\r#{line5}")
    check(stringValue)
  end

  it 'should handle multiple string data sources' do
    mValue = ValueSequence.new(lineValueCreator)
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
    fileValue = ValueSequence.new(lineValueCreator)
    fileValue.addFileDataSource("spec/fixtures/line123.txt")
    fileValue.addFileDataSource("spec/fixtures/line123.txt")
    fileValue.addFileDataSource("spec/fixtures/line123.txt")
    check123(fileValue, 0)
    check123(fileValue, 1)
    check123(fileValue, 2)
  end

  it 'should be able to mix file and string data sources' do
    valueSequence = ValueSequence.new(lineValueCreator)
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
    valueSequence = ValueSequence.new(wordValueCreator)
    valueSequence.addStringDataSource("blah blah \n\rtest one               two")
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("blah")
    expect(seqVal.location).to eq(0)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("blah")
    expect(seqVal.location).to eq(5)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("test")
    expect(seqVal.location).to eq(12)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("one")
    expect(seqVal.location).to eq(17)
    expect(seqVal.dataId).to eq(0)
    seqVal = valueSequence.nextValue
    expect(seqVal.value).to eq("two")
    expect(seqVal.location).to eq(35)
    expect(seqVal.dataId).to eq(0)
  end

  it 'should allow one ValueSequence to be data source for another' do
    valueSequence = ValueSequence.new(lineValueCreator)
    valueSequence.addFileDataSource("spec/fixtures/wordlines.txt")
    wordValueSequence = ValueSequence.new(wordValueCreator)
  end
end