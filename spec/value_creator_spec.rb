require 'rspec'

require 'sequence/file'
require 'sequence/indexed'

require_relative '../lib/creator/regex_value_creator.rb'

describe 'value creation' do
  let (:line1) { "line1" }
  let (:line2) { "line2" }
  let (:line3) { "line3" }
  let (:line4) { "no newline at end" }
  let (:lineValueCreator) {     RegexValueCreator.new(/[\n\r]/, /[^[\n\r]]/)}

  it 'should create sequence of values' do
    lineValueCreator.setSequenceSource(Sequence::Indexed.new("#{line1}\n#{line2}\n#{line3}\n#{line4}"))
    expect(lineValueCreator.nextValue.value).to eq(line1)
    expect(lineValueCreator.nextValue.value).to eq(line2)
    expect(lineValueCreator.nextValue.value).to eq(line3)
    expect(lineValueCreator.nextValue.value).to eq(line4)
  end

end


