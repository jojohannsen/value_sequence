#
#  subclasses implement nextValue
#
class ValueCreator

  def setSequenceSource(sequenceSource)
    @sequenceSource = sequenceSource
    self
  end

  def nextValue
    raise "Abstract method called"
  end

end