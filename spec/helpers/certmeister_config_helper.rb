require 'certmeister/in_memory_store'
require 'certmeister/policy/noop'

module CertmeisterConfigHelper

  def self.valid_config_options
    ca_cert = File.read('fixtures/ca.crt')
    ca_key = File.read('fixtures/ca.key')
    { ca_cert: ca_cert,
      ca_key: ca_key,
      store: Certmeister::InMemoryStore.new,
      sign_policy: Certmeister::Policy::Noop.new,
      fetch_policy: Certmeister::Policy::Noop.new,
      remove_policy: Certmeister::Policy::Noop.new }
  end

  def self.valid_config
    Certmeister::Config.new(valid_config_options)
  end

  def self.custom_config(options)
    Certmeister::Config.new(valid_config_options.merge(options))
  end

end
