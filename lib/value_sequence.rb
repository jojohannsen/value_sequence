require 'sequence/file'
require 'sequence/indexed'

class NullFilter
  def filter(value)
    return false
  end
end


class NullValueCreator

end

class ValueSequence

  def initialize
    @filter = NullFilter.new
    @transformer = Transformer.new
    @dataSources = []
    @valueCreator = NullValueCreator.new
  end

  def setCreator(valueCreator)
    @valueCreator = valueCreator
    @dataSources = valueCreator.initialDataSources if (@dataSources.length == 0)
    self
  end

  # allow values to be transformed before returning
  def addTransformer(transformer)
    @transformer.add(transformer)
    self
  end

  # filter out values
  def setFilter(filter)
    @filter = filter
    self
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
    self
  end

  # returns the next value, or nil if no more
  def nextValue
    while setDataSource do
      result = @valueCreator.nextValue
      if (@valueCreator.hasValue) then
        if (!@filter.filter(result.value)) then
          result.setValue(@transformer.transform(result.value))
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

Gem.find_files("./creator/*.rb").each { |path| require path }
Gem.find_files("./filter/*.rb").each { |path| require path }
Gem.find_files("./transformer/*.rb").each { |path| require path }
