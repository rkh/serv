require 'rack/handler/serv'
require 'rack/handler'

Serv = Rack::Handler::Serv
Rack::Handler.register 'serv', 'Serv'
