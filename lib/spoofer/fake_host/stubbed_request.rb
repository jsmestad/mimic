require 'spoofer'

module Spoofer
  class FakeHost::StubbedRequest
    attr_accessor :received

    def initialize(app, method, path)
      @method, @path = method, path
      @code = 200
      @headers = {}
      @params = {}
      @body = ""
      @app = app
      @received = false
    end

    def to_hash
      token = "#{@method} #{@path}"
      Digest::MD5.hexdigest(token)
    end

    def returning(body, code=200, headers={})
      tap do
        @body = body
        @code = code
        @headers = headers
      end
    end

    def with_query_parameters(params)
      tap do
        @params = params
      end
    end

    def echo_request!(format=:json)
      @echo_request_format = format
    end

    def matches?(request)
      if @params.any?
        request.params == @params
      else
        true
      end
    end

    def matched_response
      [@code, @headers, @body]
    end

    def unmatched_response
      [404, "", {}]
    end

    def response_for_request(request)
      if @echo_request_format
        @body = RequestEcho.new(request).to_s(@echo_request_format)
      end

      matches?(request) ? matched_response : unmatched_response
    end

    def build
      stub = self

      @app.send(@method.downcase, @path) do
        stub.received = true
        stub.response_for_request(request)
      end
    end
  end
end
