class RegexFilter
  def initialize(filter)
    @filter = filter
  end

  def filter(s)
    s =~ @filter
  end
end