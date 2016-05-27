require 'rspec'
require_relative '../lib/value/file_value_sequence'
require_relative '../lib/value/string_value_sequence'
require_relative '../lib/filter/regex_filter'

describe 'file values' do

  def check(fileValue)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(line2)
    expect(fileValue.nextValue.value).to eq(line3)
    expect(fileValue.nextValue.value).to eq(line4)
    expect(fileValue.nextValue.value).to eq(line5)
  end

  def check123(fileValue)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(line2)
    expect(fileValue.nextValue.value).to eq(line3)
  end

  let (:regexValueCreator) { RegexValueCreator.new(/[\n\r]/, /[^[\n\r]]/) }
  let (:line1) { "line1" }
  let (:line2) { "line2" }
  let (:line3) { "line3" }
  let (:line4) { "this is a test" }
  let (:line5) { "final line" }

  let (:regexFilter) { RegexFilter.new(/\w*(\/\/)+|\w*#/) }
  let (:lastfilterline) { "end line" }

  it 'should create sequence of values from a file' do
    fileValue = FileValueSequence.new(regexValueCreator)
    fileValue.addDataSource("spec/fixtures/testdata.txt")
    check(fileValue)
    fileValue = FileValueSequence.new(regexValueCreator)
    fileValue.addDataSource("spec/fixtures/testdata1.txt")
    check(fileValue)
    fileValue = FileValueSequence.new(regexValueCreator)
    fileValue.addDataSource("spec/fixtures/testdata2.txt")
    check(fileValue)
  end

  it 'should filter out values' do
    fileValue = FileValueSequence.new(regexValueCreator)
    fileValue.addDataSource("spec/fixtures/filterdata.txt")
    fileValue.addFilter(regexFilter)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(lastfilterline)
  end

  it 'should handle strings same as file' do
    stringValue = StringValueSequence.new(regexValueCreator)
    stringValue.addDataSource("#{line1}\n#{line2}\r\n#{line3}\r\r\n\n#{line4}\r#{line5}")
    check(stringValue)
  end

  it 'should handle multiple string data sources' do
    mValue = StringValueSequence.new(regexValueCreator)
    mValue.addDataSource("#{line1}")
    mValue.addDataSource("#{line2}\n\r#{line3}")
    mValue.addDataSource("#{line4}")
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
    fileValue = FileValueSequence.new(regexValueCreator)
    fileValue.addDataSource("spec/fixtures/line123.txt")
    fileValue.addDataSource("spec/fixtures/line123.txt")
    fileValue.addDataSource("spec/fixtures/line123.txt")
    check123(fileValue)
    check123(fileValue)
    check123(fileValue)
  end
end