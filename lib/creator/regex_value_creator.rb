require_relative 'value_creator.rb'
require_relative 'value_location.rb'

class RegexValueCreator < ValueCreator
  def initialize(regex, skipregex)
    @regex = regex
    @skipregex = skipregex
  end

  def setSequenceSource(sequenceSource)
    @sequenceSource = sequenceSource
    self
  end

  def nextValue
    offset = @sequenceSource.pos
    s = @sequenceSource.read_til_charset(@regex)
    @sequenceSource.read_til_charset(@skipregex)
    ValueLocation.new(s, offset)
  end
end