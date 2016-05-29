class CaseTransformer
  def initialize(direction)
    @direction = direction
  end

  def transform(value)
    if (@direction == :down) then
      return value.downcase
    elsif (@direction == :up) then
      return value.upcase
    else
      return value
    end
  end
end