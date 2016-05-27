require_relative 'value_creator.rb'
require_relative 'value_location.rb'

class RegexValueCreator < ValueCreator
  def initialize(regex, skipregex)
    super()
    @regex = regex
    @skipregex = skipregex
    @offset = @nextOffset = -1
    @sequenceSource == nil
  end

  def nextValue
    return nil if (@sequenceSource == nil)
    @sequenceSource.read_til_charset(@skipregex)
    @offset = @sequenceSource.pos
    s = @sequenceSource.read_til_charset(@regex)
    @nextOffset = @sequenceSource.pos
    return nil if (@offset == @nextOffset)
    ValueLocation.new(s, @offset, dataId)
  end

  def hasValue
    @offset != @nextOffset
  end
end