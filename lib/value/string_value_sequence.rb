require 'sequence/indexed'

require_relative 'value_sequence'

class StringValueSequence < ValueSequence

  def initialize(s, valueCreator)
    super(valueCreator.setSequenceSource(Sequence::Indexed.new(s)))
  end

end