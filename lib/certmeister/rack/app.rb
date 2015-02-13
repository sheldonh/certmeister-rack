require 'rack/request'
require 'certmeister/rack/symbolic_hash_accessor'

module Certmeister

  module Rack

    class App

      def initialize(ca)
        @ca = ca
      end

      def call(env)
        req = ::Rack::Request.new(env)
        if req.path_info == '/ping'
          if req.request_method == 'GET'
            ok('PONG')
          else
            method_not_allowed
          end
        elsif req.path_info =~ %r{^/certificate/(.+)}
          req.params['cn'] = $1
          req.params['ip'] = req.ip
          case req.request_method
            when 'POST' then sign_action(req)
            when 'GET' then fetch_action(req)
            when 'DELETE' then remove_action(req)
            else method_not_allowed
          end
        else
          not_implemented
        end
      end

      private

      def sign_action(req)
        response = @ca.sign(SymbolicHashAccessor.new(req.params))
        if response.hit?
          redirect(req.path)
        elsif response.denied?
          forbidden(response.error)
        else
          internal_server_error(response.error)
        end
      end

      def fetch_action(req)
        response = @ca.fetch(SymbolicHashAccessor.new(req.params))
        if response.hit?
          ok(response.pem, 'application/x-pem-file')
        elsif response.miss?
          not_found
        elsif response.denied?
          forbidden(response.error)
        else
          internal_server_error(response.error)
        end
      end

      def remove_action(req)
        response = @ca.remove(SymbolicHashAccessor.new(req.params))
        if response.hit?
          ok
        elsif response.miss?
          not_found
        elsif response.denied?
          forbidden(response.error)
        else
          internal_server_error(response.error)
        end
      end

      def ok(body = '200 OK', content_type = 'text/plain')
        [200, {'Content-Type' => content_type}, [body]]
      end

      def redirect(location)
        [303, {'Content-Type' => 'text/plain', 'Location' => location}, ['303 See Other']]
      end

      def not_found
        [404, {'Content-Type' => 'text/plain'}, ["404 Not Found"]]
      end

      def forbidden(reason)
        [403, {'Content-Type' => 'text/plain'}, ["403 Forbidden (#{reason})"]]
      end

      def method_not_allowed
        [405, {'Content-Type' => 'text/plain'}, ['405 Method Not Allowed']]
      end

      def internal_server_error(reason)
        [500, {'Content-Type' => 'text/plain'}, ["500 Internal Server Error (#{reason})"]]
      end

      def not_implemented
        [501, {'Content-Type' => 'text/plain'}, ['501 Not Implemented']]
      end

    end

  end

end
