require 'sequence/file'

class ValueSequence
  attr_reader :lastValuePosition, :done

  def initialize(valueCreator)
    @filters = []
    @dataSources = []
    @done = false
    @valueCreator = valueCreator
  end

  def addFilter(filter)
    @filters << filter
  end

  def setSequenceSource(sequence)
    @dataSources << sequence
  end

  def nextValue
    while true do
      setDataSource
      result = @valueCreator.nextValue()
      if (@valueCreator.hasValue) then
        if (!@filters.any? { |filter| filter.matches result.value }) then
          return result
        end
      else
        @valueCreator.setSequenceSource(nil)
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

