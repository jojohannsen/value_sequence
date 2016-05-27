require 'sequence/file'
require 'sequence/indexed'

class ValueSequence

  def initialize(valueCreator)
    @filters = []
    @dataSources = []
    @valueCreator = valueCreator
  end

  def addFilter(filter)
    @filters << filter
  end

  def addStringDataSource(s)
    addSequenceSource(Sequence::Indexed.new(s))
  end

  def addFileDataSource(filePath)
    addSequenceSource(Sequence::File.new(File.new(filePath)))
  end

  def addSequenceSource(sequence)
    @dataSources << sequence
  end

  def nextValue
    while true do
      setDataSource
      result = @valueCreator.nextValue
      if (@valueCreator.hasValue) then
        if (!@filters.any? { |filter| filter.matches result.value }) then
          return result
        end
      else
        @valueCreator.resetSequenceSource
      end
    end
    return nil
  end

  private

    def setDataSource
      if ((@valueCreator.sequenceSource == nil) && (@dataSources.length > 0)) then
        @valueCreator.setSequenceSource(@dataSources.shift)
      end
    end

end

