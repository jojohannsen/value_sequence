class Transformer
  def initialize
    @transformers = []
  end

  def add(transformer)
    @transformers << transformer
  end

  def transform(value)
    @transformers.each do |transformer|
      value = transformer.transform(value)
    end
    value
  end
end