Gem::Specification.new do |gem|
  gem.name        = 'value_sequence'
  gem.version     = '0.0.1'
  gem.date        = '2016-05-25'
  gem.summary     = "Sequence of values"
  gem.description = "Converts data into sequences of values"
  gem.authors     = ["Johannes Johannsen"]
  gem.email       = 'johannes.johannsen@gmail.com'
  gem.files       = Dir.glob("{lib,spec}/**/*")
  gem.homepage    =
      'http://rubygems.org/gems/value_sequence'
  gem.license       = 'MIT'
  gem.add_runtime_dependency(%q<sequence>, [">= 0.2.3"])
end