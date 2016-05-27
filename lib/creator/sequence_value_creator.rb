#
#  this is for chaining together sequence value creators
#  the incomingValueSequence provides data sources for the outgoingValueSequence
#  so whenever the outgoingValueSequence returns a nil, it gets a new data source
#  from the incomingValueSequence
#
class SequenceValueCreator < ValueCreator
  def initialize(incomingValueSequence, outgoingValueSequence)
    super()
    @incomingValueSequence = incomingValueSequence
    @outgoingValueSequence = outgoingValueSequence
    @locationOffset = 0
  end

  def nextValue
    result = @outgoingValueSequence.nextValue
    while (result == nil) do
      inResult = @incomingValueSequence.nextValue
      if (inResult == nil) then
        return nil
      else
        @locationOffset = inResult.location
        @outgoingValueSequence.addStringDataSource(inResult.value)
        result = @outgoingValueSequence.nextValue
      end
    end
    if (result != nil) then
      result.addLocationOffset(@locationOffset)
    end
    result
  end

  def hasValue
    @outgoingValueSequence.hasValue
  end

  def initialDataSources
    [ "non-nil" ]
  end
end