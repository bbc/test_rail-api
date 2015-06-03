Gem::Specification.new do |s|

  s.name        = 'test_rail-api'
  s.version     = '0.3.1'
  s.date        = '2014-05-05'
  s.summary     = 'Test Rail API'
  s.description = 'Ruby Client for v2 TestRail API'
  s.authors     = ['David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = `git ls-files -z`.split("\x0")
  s.homepage    = 'https://github.com/bbc/test_rail-api'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'virtus'

  s.add_development_dependency 'rspec', "~> 2.14"
  s.add_development_dependency 'faker'
end
