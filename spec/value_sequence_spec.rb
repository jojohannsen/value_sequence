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

  let (:regexValueCreator) { RegexValueCreator.new(/[\n\r]/, /[^[\n\r]]/) }
  let (:line1) { "line1" }
  let (:line2) { "line2" }
  let (:line3) { "line3" }
  let (:line4) { "this is a test" }
  let (:line5) { "final line" }

  let (:regexFilter) { RegexFilter.new(/\w*(\/\/)+|\w*#/) }
  let (:lastfilterline) { "end line" }

  it 'should create sequence of values from a file' do
    fileValue = FileValueSequence.new("spec/fixtures/testdata.txt", regexValueCreator)
    check(fileValue)
    fileValue = FileValueSequence.new("spec/fixtures/testdata1.txt", regexValueCreator)
    check(fileValue)
    fileValue = FileValueSequence.new("spec/fixtures/testdata2.txt", regexValueCreator)
    check(fileValue)
  end

  it 'should filter out values' do
    fileValue = FileValueSequence.new("spec/fixtures/filterdata.txt", regexValueCreator)
    fileValue.addFilter(regexFilter)
    expect(fileValue.nextValue.value).to eq(line1)
    expect(fileValue.nextValue.value).to eq(lastfilterline)
  end

  it 'should handle strings same as file' do
    stringValue = StringValueSequence.new("#{line1}\n#{line2}\r\n#{line3}\r\r\n\n#{line4}\r#{line5}", regexValueCreator)
    check(stringValue)
  end
end