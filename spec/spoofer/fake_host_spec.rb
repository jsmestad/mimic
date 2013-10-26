require 'spec_helper'

describe Spoofer::FakeHost do
  let(:host) { described_class.new(:hostname => "www.example.com") }

  it "should handle stubbed requests" do
    host.get("/some/path")
    host.call(request_for("/some/path")).should match_rack_response(200, {}, "")
  end

  it "should handle stubbed requests that return a response" do
    host.get("/some/path").returning("hello world")
    host.call(request_for("/some/path")).should match_rack_response(200, {}, "hello world")
  end

  it "should handle stubbed requests that return a specific HTTP code" do
    host.get("/some/path").returning("redirecting", 301)
    host.call(request_for("/some/path")).should match_rack_response(301, {}, "redirecting")
  end

  it "should handle stubbed requests that return specific headers" do
    host.get("/some/path").returning("redirecting", 301, {"Location" => "http://somewhereelse.com"})
    host.call(request_for("/some/path")).should match_rack_response(301, {"Location" => "http://somewhereelse.com"}, "redirecting")
  end

  it "should not recognize requests if they have the incorrect HTTP method" do
    host.get("/some/path")
    host.call(request_for("/some/path", :method => "POST")).should match_rack_response(404, {}, "")
  end

  it "should not handle multiple requests to a path with different HTTP methods" do
    host.get("/some/path").returning("GET Request", 200)
    host.post("/some/path").returning("POST Request", 201)
    host.call(request_for("/some/path", :method => "GET")).should match_rack_response(200, {}, "GET Request")
    host.call(request_for("/some/path", :method => "POST")).should match_rack_response(201, {}, "POST Request")
  end

  it "should handle requests with behaviour specified in a block using the Sinatra API" do
    host.get("/some/path") do
      content_type 'text/plain'
      'bobby'
    end
    host.call(request_for("/some/path", :method => "GET")).should match_rack_response(200, {'Content-Type' => 'text/plain;charset=utf-8'}, 'bobby')
  end

  it "should allow stubs to be cleared" do
    host.get("/some/path")
    host.call(request_for("/some/path")).should match_rack_response(200, {}, "")
    host.clear
    host.call(request_for("/some/path")).should match_rack_response(404, {}, "")
  end

  it "should allow stubs to be imported from a file" do
    host.import(File.join(File.dirname(__FILE__), *%w[.. fixtures import_stubs.spoof]))
    host.call(request_for("/imported/path")).should match_rack_response(200, {}, "")
  end

  it "should not clear imported stubs" do
    host.import(File.join(File.dirname(__FILE__), *%w[.. fixtures import_stubs.spoof]))
    host.clear
    host.call(request_for("/imported/path")).should match_rack_response(200, {}, "")
  end

  it "should raise if import file does not exist" do
    proc {
      host.import(File.join(File.dirname(__FILE__), *%w[.. fixtures doesnt_exist.spoof]))
    }.should raise_error
  end

  it "returns a StubbedRequest" do
    host.get("/some/path").should be_kind_of(Spoofer::FakeHost::StubbedRequest)
  end

end
