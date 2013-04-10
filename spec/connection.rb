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

  context "when logged out" do
    it { @connection.should_not be_logged_in }

    describe "#login" do
      it "should succeed" do
        stub_request( :post, "http://10.0.0.1/nitro/v1/config").
        with(:body => {"object"=>"{\"login\":{\"username\":\"user\",\"password\":\"pass\"}}"},
          :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/x-www-form-urlencoded'}).
        to_return({ :body => '{"errorcode": 0, "message": "Done", "sessionid": "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5" }', :status => 200, :headers => {'Content-Type' => 'application/json' }})
 
        @connection.login.should be_eql "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"
      end
    end

    describe "#logout" do
    end
  end

  context "when logged in" do
    it { @connection.should be_logged_in }
    describe "#login" do
      it { @connection.login.should be_eql "##CCD41760A2B71E88E029BC33F00E9C24704E71821EB86BD9A3AD2E5005C5"}
    end
    
    describe "#logout" do
    end
  end
end
