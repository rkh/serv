Gem::Specification.new do |s|
  s.name        = 'serv'
  s.version     = '0.2.0'
  s.date        = '2011-01-08'
  s.description = 'simple, threaded rack handler (webserver)'
  s.summary     = s.description
  s.authors     = ['Konstantin Haase']
  s.email       = 'k.haase@finn.de'
  s.files       = `git ls-files`.split("\n")
  s.add_dependency 'http_parser.rb'
end
