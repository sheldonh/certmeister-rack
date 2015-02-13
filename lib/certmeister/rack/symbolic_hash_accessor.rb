require 'delegate'

# Light-weight alternative to active_support's HashWithIndifferentAccess.
#
# The rack application must not symbolize params from the client, because
# symbols cannot be garbage-collected, and so provide a memory starvation
# attack.
#
# So instead we wrap the parameters with a symbolic accessor, so that
# Certmeister::Base and Certmeister::Policy::* can refer to parameters
# symbolically.

module Certmeister

  module Rack

    class SymbolicHashAccessor < SimpleDelegator

      def initialize(hash)
        @hash = hash
        super(@hash)
      end

      def [](key)
        @hash[key.to_s]
      end

      def fetch(*args)
        args[0] = args[0].to_s
        @hash.fetch(*args)
      end

      def has_key?(key)
        @hash.has_key?(key.to_s)
      end
      alias_method :include?, :has_key?

    end

  end

end
