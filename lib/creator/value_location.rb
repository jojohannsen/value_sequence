class ValueLocation
  attr_reader :value, :location, :dataId

  def initialize(value, location, dataId)
    @value = value
    @location = location
    @dataId = dataId
  end

  def updateLocation(offset, dataId)
    @location += offset
    @dataId = dataId
  end
end
