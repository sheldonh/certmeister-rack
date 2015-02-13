require 'rubygems'
require 'rack'

require 'certmeister'
require 'certmeister/redis/store'
require 'certmeister/rack/app'
require 'redis'

store = Certmeister::Redis::Store.new(Redis.new, "development")

sign_policy = Certmeister::Policy::ChainAny.new([
  Certmeister::Policy::ChainAll.new([
    Certmeister::Policy::Existing.new(store),
    Certmeister::Policy::Domain.new(['host-h.net']),
    Certmeister::Policy::Fcrdns.new,
  ]),
  Certmeister::Policy::ChainAll.new([
    Certmeister::Policy::Existing.new(store),
    Certmeister::Policy::Domain.new(['example.com']),
    Certmeister::Policy::IP.new(['192.168.0.0/23']),
  ]),
  Certmeister::Policy::IP.new(['127.0.0.1/32']),
])
fetch_policy = Certmeister::Policy::Noop.new
remove_policy = Certmeister::Policy::IP.new(['192.168.0.0/23', '127.0.0.1/32'])

ca = Certmeister.new(
  Certmeister::Config.new(
    sign_policy: sign_policy,
    fetch_policy: fetch_policy,
    remove_policy: remove_policy,
    store: store,
    ca_cert: File.read("../fixtures/ca.crt"),
    ca_key: File.read("../fixtures/ca.key"),
  )
)
certmeister = Certmeister::Rack::App.new(ca)

app = Rack::Builder.new do
  map "/ca" do
    run certmeister
  end
end

run app
