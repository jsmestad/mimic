module Spoofer
  class API::Stub
    def initialize(data, method = nil)
      @data = data
      @method = method
    end

    def on(host)
      host.send(@method.downcase.to_sym, path).returning(body, code, headers).tap do |stub|
        stub.with_query_parameters(params)
        stub.echo_request!(echo_format)
      end
    end

    def echo_format
      @data['echo'].to_sym rescue nil
    end

    def path
      @data['path'] || '/'
    end

    def body
      @data['body'] || ''
    end

    def code
      @data['code'] || 200
    end

    def headers
      @data['headers'] || {}
    end

    def params
      @data['params'] || {}
    end
  end
end
