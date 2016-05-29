require_relative 'value_creator.rb'
require_relative 'value_location.rb'

class CharacterValueCreator < ValueCreator

  def nextValue
    return nil if (@sequenceSource == nil)
    @offset = @sequenceSource.pos
    @lastResult = @sequenceSource.read1
    return nil if (@lastResult.nil?)
    ValueLocation.new(@lastResult, @offset, dataId)
  end

  def hasValue
    @lastResult != nil
  end

end