#
#  subclasses implement nextValue
#
class ValueCreator
  attr_reader :sequenceSource, :dataId

  def initialize()
    @dataId = -1
    @sequenceSource = nil
  end

  def setSequenceSource(sequenceSource)
    if (sequenceSource != @sequenceSource) then
      @sequenceSource = sequenceSource
      @dataId += 1 if sequenceSource != nil
    end
  end

  def resetSequenceSource()
    @sequenceSource = nil
  end

  def nextValue
    null
  end

  def hasValue
    false
  end

  def initialDataSources
    []
  end
end