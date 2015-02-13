module Certmeister

  module Rack

  end

end

Dir.glob(File.join(File.dirname(__FILE__), "rack", "*.rb")) do |path|
  require path
end
