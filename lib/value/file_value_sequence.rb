require 'sequence/file'

require_relative 'value_sequence'

class FileValueSequence < ValueSequence

  def initialize(filePath, valueCreator)
    super()
    @valueCreator = valueCreator.setSequenceSource(Sequence::File.new(File.new(filePath)))
  end

end

