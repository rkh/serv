Gem::Specification.new do |s|
  s.name        = 'serv'
  s.version     = '0.1'
  s.date        = '2010-10-20'
  s.description = 'simple, threaded rack handler (webserver)'
  s.summary     = s.description
  s.authors     = ['Konstantin Haase']
  s.email       = 'k.haase@finn.de'
  s.files       = `git ls-files`.split("\n")
  s.add_dependency 'ruby_http_parser'
end
