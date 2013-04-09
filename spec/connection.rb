require "rspec_helper"
require "webmock/rspec"

describe Netscaler::Connection do
  before(:all) do
    @connection = Netscaler::Connection.new({"username" => "lp", "password" => "test", "hostname" => "10.0.0.1"})
  end

  describe "#new" do
    it "takes a hash as parameter" do
      @connection.should be_an_instance_of Netscaler::Connection
    end
  end

  describe "#login" do
    stub_request 
  end
end
