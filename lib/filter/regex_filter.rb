class RegexFilter
  def initialize(filter)
    @filter = filter
  end

  def matches(s)
    s =~ @filter
  end
end