require 'spec_helper'
require 'rack/test'
require 'helpers/certmeister_config_helper'

require 'certmeister'
require 'certmeister/rack'

describe Certmeister::Rack::SelfTestApp do

  include Rack::Test::Methods

  let(:response) { double(Certmeister::Response).as_null_object }
  let(:ca) { Certmeister.new(CertmeisterConfigHelper::valid_config) }
  let(:self_test) { Certmeister::SelfTest.new(ca, File.read('fixtures/client.key')) }
  let(:app) { Certmeister::Rack::SelfTestApp.new(self_test) }

  describe "GET /test" do

    context "when the CA is functioning" do

      before(:each) do
        #allow(ca).to receive(sign).and_raise("Nobody expects the Spanish Inquisition!")
        get "/test"
      end

      it "returns 200" do
        expect(last_response.status).to eql 200
      end

      it "describes the HTTP status in the body" do
        expect(last_response.body).to eql '200 OK'
      end

      it "describes the body as text/plain" do
        expect(last_response.headers['Content-Type']).to eql 'text/plain'
      end

    end

    context "when the CA is broken" do

      before(:each) do
        allow(ca).to receive(:sign).and_raise("Nobody expects the Spanish Inquisition!")
        get "/test"
      end

      it "returns 503" do
        expect(last_response.status).to eql 503
      end

      it "describes the error in the body" do
        expect(last_response.body).to match /the Spanish Inquisition/
      end

      it "describes the body as text/plain" do
        expect(last_response.headers['Content-Type']).to eql 'text/plain'
      end

    end

  end

end
