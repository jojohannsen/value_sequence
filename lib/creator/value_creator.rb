#
#  subclasses implement nextValue
#
class ValueCreator
  attr_reader :sequenceSource, :dataId

  def initialize()
    @dataId = -1
  end

  def setSequenceSource(sequenceSource)
    if (sequenceSource != @sequenceSource) then
      @sequenceSource = sequenceSource
      @dataId += 1 if sequenceSource != nil
    end
  end

  def nextValue
    raise "Abstract method called"
  end

end