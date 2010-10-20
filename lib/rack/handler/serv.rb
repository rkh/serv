require 'ruby_http_parser'
require 'stringio'
require 'socket'
require 'rack/utils'

module Rack
  module Handler
    class Serv
      VERSION = "0.1"
      def self.run(app, options = {})
        Thread.abort_on_exception = true
        @@host, @@port = options[:Host] || '0.0.0.0', options[:Port] || 8080
        s = TCPServer.new(@@host, @@port)
        puts "listening #{options.inspect}"
        loop { Thread.new(s.accept) { |io| new app, io }}
      end

      def initialize(app, socket)
        puts "incoming"
        @app, @socket, @done        = app, socket, false
        parser                      = Net::HTTP::RequestParser.new
        @body                       = ""
        parser.on_body              = proc { |b| @body << b }
        parser.on_message_complete  = self
        parser << (first_line = @socket.gets)
        @verb, @path, @http = first_line.split(' ')
        parser << @socket.gets until @done
      rescue Net::HTTP::ParseError
        @socket.close
      end

      def call(env)
        @done = true
        env.merge! \
          "REQUEST_METHOD"    => @verb,
          "rack.input"        => StringIO.new(@body),
          "rack.version"      => Rack::VERSION,
          "rack.errors"       => $stderr,
          "rack.multithread"  => true,
          "rack.multiprocess" => false,
          "rack.run_once"     => false,
          "rack.url_scheme"   => %w[yes on 1].include?(ENV["HTTPS"]) ? "https" : "http"
        env["SERVER_NAME"]  ||= env["HTTP_HOST"] || @@host
        env["SERVER_PORT"]  ||= @@port.to_s
        env["QUERY_STRING"] ||= ""
        status, headers, body = @app.call(env)
        @socket.puts "#{@http} #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]}"
        @socket.puts headers.map { |k,v| "#{k}: #{v}" }
        @socket.puts ''
        body.each do |line|
          @socket.print line
          @socket.flush
        end
        body.close if body.respond_to? :close
        @socket.close
      end
    end
  end
end
