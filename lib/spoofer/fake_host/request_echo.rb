module Spoofer
  class FakeHost::RequestEcho
    def initialize(request)
      @request = request
    end

    def response_as(format)
      content_type = case format
      when :json, :plist
        "application/#{format.to_s.downcase}"
      else
        "text/plain"
      end
      [200, {"Content-Type" => content_type}, to_s(format)]
    end

    def to_s(format)
      case format
        when :json
          to_hash.to_json
        when :plist
          to_hash.to_plist
        when :text
          to_hash.inspect
      end
    end

    def to_hash
      {"echo" => {
        "params" => @request.params,
        "env"    => env_without_rack_and_async_env,
        "body"   => @request.body.read
      }}
    end

  private

    def env_without_rack_and_async_env
      Hash[*@request.env.select { |key, value| key !~ /^(rack|async)/i }.flatten]
    end
  end
end
