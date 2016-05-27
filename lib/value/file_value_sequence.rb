require 'sequence/file'

require_relative 'value_sequence'

class FileValueSequence < ValueSequence

  def initialize(valueCreator)
    super(valueCreator)
  end

  def addDataSource(filePath)
    setSequenceSource(Sequence::File.new(File.new(filePath)))
  end

end

