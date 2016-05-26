class ValueLocation
  attr_reader :value, :location

  def initialize(value, location)
    @value = value
    @location = location
  end
end
