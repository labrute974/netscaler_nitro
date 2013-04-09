require "rspec_helper"
require "webmock/rspec"

describe Netscaler::Connection do
  before(:all) do
    @connection = Netscaler::Connection.new({"username" => "user", "password" => "pass", "hostname" => "10.0.0.1"})
  end

  describe "#new" do
    it "takes a hash as parameter" do
      @connection.should be_an_instance_of Netscaler::Connection
    end
  end

  describe "#login" do
    it "should succeed" do
      stub_request( :post, "http://10.0.0.1/nitro/v1/config").
        with(:body => {"object"=>"{\"login\":{\"username\":\"user\",\"password\":\"pass\"}}"},
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "sessionid": "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5" }', :status => 200, :headers => {'Content-Type' => 'application/json' }})

      session_id = @connection.login

      if session_id == "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"
        return true
      else
        return false
      end
    end
  end

  context "when logged in" do
  end

  context "when not logged in" do
  end
end
