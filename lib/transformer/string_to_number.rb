class StringToNumber
  def initialize
    @valueToNumber = {}
    @nextNumber = 0
  end

  def transform(value)
    value = value.downcase
    if (@valueToNumber.has_key?(value)) then
      return @valueToNumber[value]
    else
      @nextNumber += 1
      @valueToNumber[value] = @nextNumber
      return @nextNumber
    end
  end
end