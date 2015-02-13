module Certmeister

  module Rack

    class SelfTestApp

      def initialize(self_test)
        @self_test = self_test
      end

      def call(env)
        res = @self_test.test
        if res.ok?
          ok
        else
          service_unavailable(res.message)
        end
      end

      private

        def ok(body = '200 OK', content_type = 'text/plain')
          [200, {'Content-Type' => content_type}, [body]]
        end

        def service_unavailable(reason)
          [503, {'Content-Type' => 'text/plain'}, [reason]]
        end

    end

  end

end
