require 'spoofer'

module Spoofer
  module FakeHost::Helpers
    def echo_request!(format)
      RequestEcho.new(request).response_as(format)
    end
  end
end


