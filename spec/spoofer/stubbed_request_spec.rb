require 'spec_helper'

describe Spoofer::FakeHost::StubbedRequest do
  let(:host) { Spoofer::FakeHost.new(:hostname => "www.example.com") }

  it "has a unique hash based on it's parameters" do
    host = described_class.new(double, "GET", "/path")
    host.to_hash.should == Digest::MD5.hexdigest("GET /path")
  end

  it "has the same hash as an equivalent request" do
    host_one = described_class.new(double, "GET", "/path")
    host_two = described_class.new(double, "GET", "/path")
    host_one.to_hash.should == host_two.to_hash
  end
end
