require 'sequence/file'
require 'sequence/indexed'

class ValueSequence

  def initialize(valueCreator)
    @filters = []
    @transformer = nil
    @dataSources = valueCreator.initialDataSources
    @valueCreator = valueCreator
  end

  # allow values to be transformed before returning
  def setTransformer(transformer)
    @transformer = transformer
  end

  # filter out values
  def addFilter(filter)
    @filters << filter
  end

  # string specific data source
  def addStringDataSource(s)
    addSequenceSource(Sequence::Indexed.new(s))
  end

  # file specific data source
  def addFileDataSource(filePath)
    addSequenceSource(Sequence::File.new(File.new(filePath)))
  end

  # generic sequence data source
  def addSequenceSource(sequence)
    @dataSources << sequence
  end

  # returns the next value, or nil if no more
  def nextValue
    while setDataSource do
      result = @valueCreator.nextValue
      if (@valueCreator.hasValue) then
        if (!@filters.any? { |filter| filter.matches result.value }) then
          if (@transformer != nil) then
            result.setValue(@transformer.transform(result.value))
          end
          return result
        end
      else
        @valueCreator.resetSequenceSource
      end
    end
    return nil
  end

  # returns true if the creator provided a value
  def hasValue
    @valueCreator.hasValue
  end

  private

    # returns true if we have a valid sequenceSource
    def setDataSource
      if ((@valueCreator.sequenceSource == nil) && (@dataSources.length > 0)) then
        @valueCreator.setSequenceSource(@dataSources.shift)
      end
      @valueCreator.sequenceSource
    end

end

