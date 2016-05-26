require 'sequence/file'

class ValueSequence
  attr_reader :lastValuePosition, :done

  def initialize(valueCreator)
    @lastValuePosition = -1
    @filters = []
    @done = false
    @valueCreator = valueCreator
  end

  def addFilter(filter)
    @filters << filter
  end

  def nextValue
    while !@done do
      result = @valueCreator.nextValue()
      if (result.location != @lastValuePosition) then
        if (!@filters.any? { |filter| filter.matches result.value }) then
          @lastValuePosition = result.location
          return result
        end
      else
        @done = true
      end
    end
    return nil
  end
end

