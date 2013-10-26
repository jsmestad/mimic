require 'spoofer'

module Spoofer
  class API < Sinatra::Base
    class << self
      attr_accessor :host
    end

    def host
      self.class.host
    end

    %w{get post put delete head}.each do |verb|
      post "/#{verb}" do
        api_request = APIRequest.from_request(request, verb)
        api_request.setup_stubs_on(host)
        [201, {"Content-Type" => api_request.request_content_type}, api_request.response]
      end
    end

    post "/multi" do
      api_request = APIRequest.from_request(request)
      api_request.setup_stubs_on(host)
      [201, {"Content-Type" => api_request.request_content_type}, api_request.response]
    end

    post "/clear" do
      response_body = self.host.inspect
      self.host.clear
      [200, {}, "Cleared stubs: #{response_body}"]
    end

    get "/ping" do
      [200, {}, "OK"]
    end

    get "/debug" do
      [200, {}, self.host.inspect]
    end

    get "/requests" do
      [200, {"Content-Type" => "application/json"}, {"requests" => host.received_requests.map(&:to_hash)}.to_json]
    end

  private

    autoload :ApiRequest, 'spoofer/api/api_request'
    autoload :Stub, 'spoofer/api/stub'
  end
end
