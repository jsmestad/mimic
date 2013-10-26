require 'spoofer'

module Spoofer
  class API::APIRequest
    attr_reader :request_content_type

    def self.from_request(request, method = nil)
      case request.content_type
        when /json/
          data = JSON.parse(request.body.string)
        when /plist/
          data = Plist.parse_xml(request.body.string)
        else
          data = JSON.parse(request.body.string)
      end
      new(data, method, request.content_type)
    end

    def initialize(data, method = nil, request_content_type = '')
      @data = data
      @method = (method || "GET")
      @stubs = []
      @request_content_type = request_content_type
    end

    def to_s
      @data.inspect
    end

    def response
      response = {"stubs" => @stubs.map(&:to_hash)}

      case request_content_type
      when /json/
        response.to_json
      when /plist/
        response.to_plist
      else
        response.to_json
      end
    end

    def setup_stubs_on(host)
      (@data["stubs"] || [@data]).each do |stub_data|
        @stubs << Stub.new(stub_data, stub_data['method'] || @method).on(host)
      end
    end
  end
end
