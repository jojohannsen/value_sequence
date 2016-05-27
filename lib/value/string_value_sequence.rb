require 'sequence/indexed'

require_relative 'value_sequence'

class StringValueSequence < ValueSequence

  def initialize(valueCreator)
    super(valueCreator)
  end

  def addDataSource(s)
    setSequenceSource(Sequence::Indexed.new(s))
  end

end