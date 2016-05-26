require 'rspec'
require_relative '../lib/creator/value_location'

describe 'Value location pair' do

  it 'should verify simple instance' do
    vl = ValueLocation.new(3, 100)
    expect(vl.value).to eq(3)
    expect(vl.location).to eq(100)
  end
end