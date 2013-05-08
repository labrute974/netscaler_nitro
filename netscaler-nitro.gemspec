Gem::Specification.new do |s|
  s.name        = 'netscaler-nitro'
  s.version     = '0.0.1'
  s.date        = '2013-05-07'
  s.summary     = "Netscaler Nitro API gem."
  s.description = "Netscaler Nitro API gem"
  s.authors     = ["Karel Malbroukou"]
  s.email       = 'karel.malbroukou@gmail.com'
  s.files = Dir['lib/**/*.rb']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'

  s.requirements << 'rest-client'
  s.requirements << 'json'
  s.license = 'GPL-2'
end
